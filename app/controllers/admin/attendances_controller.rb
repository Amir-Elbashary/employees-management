class Admin::AttendancesController < Admin::BaseAdminController
  layout :resolve_layout
  rescue_from JWT::ExpiredSignature, JWT::DecodeError, with: :token_expired
  skip_before_action :authenticate, only: %i[remote_checkout postpone_checkout_reminder]
  skip_before_action :ensure_active_employee!, only: %i[remote_checkout postpone_checkout_reminder]
  load_and_authorize_resource
  skip_load_resource only: %i[index reports grant revoke remote_checkout postpone_checkout_reminder]
  before_action :require_authorized_network, only: %i[checkin checkout]
  before_action :require_authorized_device, only: %i[checkin checkout]
  before_action :set_attendances, only: :index
  before_action :set_resource, only: :append
  before_action :set_times, only: :append
  before_action :set_resources, only: %i[index reports]
  before_action :set_date_ranges, only: :reports
  before_action :set_workdays, only: :reports
  before_action :set_holidays, only: :reports
  before_action :set_reports_entities, only: :reports
  before_action :set_employee, only: %i[grant revoke]
  before_action :set_messages, only: %i[checkin checkout]

  def index
    return unless current_employee_token_expired?
    cookies[:ft_att_ver] = { value: current_employee.access_token, expires: 1.year }
    current_employee.token_verified!
  end

  def grant
    return unless @employee.access_token == 'expired'
    return unless @employee.update(access_token: SecureRandom.hex)
    flash[:notice] = "#{@employee.full_name} access has been granted."
    redirect_to admin_employees_path
  end

  def revoke
    return unless @employee.update(access_token: 'expired', access_token_status: 'waiting_for_token')
    flash[:notice] = "#{@employee.full_name} access has been revoked."
    redirect_to admin_employees_path
  end

  def checkin
    if @current_attendance
      flash[:notice] = "You have already checked-in today, #{@messages[:checkin].sample}"
    else
      attendance = Attendance.create(attender: current_active_user, checkin: Time.zone.now)
      send_checkout_reminder(attendance)
      flash[:notice] = "Thank you #{current_active_user.first_name}, Wishing you good and productive day."
    end

    redirect_to request.referer
  end

  def checkout
    if @current_attendance&.checkout
      flash[:notice] = "You have already checked-out today, #{@messages[:checkout].sample}"
    elsif @current_attendance&.update(checkout: Time.zone.now)
      perform_checkout
    else
      flash[:danger] = 'You haven\'t check-in today yet, Let\'s start a productive day!'
    end

    redirect_to request.referer
  end

  def remote_checkout
    return unless params[:token]
    data = JWT.decode(params[:token], hmac_secret, true, algorithm: 'HS256')[0]
    return redirect_to remote_checkout_admin_attendances_path(error: 3) unless ip_address_authorized?
    @current_attendance = Attendance.find(data['attendance_id'])
    return redirect_to remote_checkout_admin_attendances_path(error: 1) if @current_attendance.checkout
    checkout_time = if @settings.add_remaining_checkout_time?
                      Time.zone.now + @settings.checkout_reminder_minutes.minutes
                    else
                      Time.zone.now
                    end
    perform_checkout if @current_attendance&.update(checkout: checkout_time)
    redirect_to remote_checkout_admin_attendances_path(success: true)
  end

  def postpone_checkout_reminder
    return unless params[:token]
    data = JWT.decode(params[:token], hmac_secret, true, algorithm: 'HS256')[0]
    return redirect_to postpone_checkout_reminder_admin_attendances_path(error: 3) unless ip_address_authorized?
    @current_attendance = Attendance.find(data['attendance_id'])
    return redirect_to postpone_checkout_reminder_admin_attendances_path(error: 1) if @current_attendance.checkout

    return unless params[:time]

    postpone_reminder
    redirect_to postpone_checkout_reminder_admin_attendances_path(success: true, time: params[:time])
  end

  def checkin_reminder
    cookies[:ft_att_ci_rem] = { value: 'hidden', expires: 2.hours }
    redirect_to request.referer
  end

  def checkout_reminder
    cookies[:ft_att_co_rem] = { value: 'hidden', expires: 2.hours }
    redirect_to request.referer
  end

  def append
    @check_type = params[:check_type]
    attendance = @resource.attendances&.where(checkin: @checktime_utc_day_range)&.first

    if @check_type == 'Check-in'
      append_checkin(attendance, @resource, @checktime_utc)
    elsif @check_type == 'Check-out'
      append_checkout(attendance, @checktime_utc)
    end

    redirect_to admin_attendances_path
  end

  def reports
    set_attendances_and_vacations if @resource
    set_actual_work_days_and_hours
    set_actual_vacations if @vacation_requests
    set_total_work_days_and_hours
  end

  private

  def require_authorized_network
    return if @approved_wfh_requests&.any?
    return unless current_employee
    return if ip_address_authorized?
    flash[:danger] = 'Unauthorized network detected, Please connect to an authorized network!'
    redirect_to admin_path
  end

  def require_authorized_device
    return unless current_employee
    return if cookies[:ft_att_ver] == current_employee.access_token
    flash[:danger] = 'Unauthorized device detected, Please connect via an authorized device!'
    redirect_to admin_path
  end

  def ip_address_authorized?
    return true if @settings.ip_addresses.include?(request.remote_ip)
    return true if @settings.ip_addresses[0]&.split(',')&.include?(request.remote_ip)
  end

  def current_employee_token_expired?
    return false unless current_employee
    return false unless current_employee.access_token != 'expired' && current_employee.waiting_for_token?
    true
  end

  def set_attendances
    @employees = Employee.all unless current_employee
    @attendance = Attendance.new
    @attendances = if current_employee
                     current_employee.attendances.limit(31)
                   elsif current_admin || current_hr
                     Attendance.limit(31)
                   end
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_resources
    @admins = Admin.all
    @hrs = Hr.all
    @employees = Employee.all
  end

  def set_resource
    resource_type = params[:employee].split('-').first
    resource_id = params[:employee].split('-').last
    @resource = resource_type.constantize.find(resource_id)
  end

  def set_times
    checktime = params[:checktime].to_datetime
    @checktime_utc = DateTime.new(checktime.year, checktime.month, checktime.day,
                                  checktime.hour, checktime.minute, checktime.second, 'EET').utc
    @checktime_utc_day_range = @checktime_utc.at_beginning_of_day..@checktime_utc.at_end_of_day
  end

  def append_checkin(attendance, resource, checktime_utc)
    if attendance
      flash[:danger] = 'Employee already checked-in'
    else
      flash[:notice] = 'Check-in appended'
      Attendance.create(attender: resource, checkin: checktime_utc)
    end
  end

  def append_checkout(attendance, checktime_utc)
    if attendance
      if attendance.checkout
        flash[:danger] = 'Employee already checked-out'
      else
        flash[:notice] = 'Check-out appended'
        checkin = attendance.checkin.to_datetime
        time_spent = ((checktime_utc.to_f - checkin.to_f) / 60 / 60).round(2)
        attendance.update(checkout: checktime_utc, time_spent: time_spent)
      end
    else
      flash[:danger] = 'Employee has not checked-in during selected day'
    end
  end

  def perform_checkout
    time_spent = calculate_time_spent
    @current_attendance.update(time_spent: time_spent)
    flash[:notice] = "Thanks #{current_active_user.first_name}, See you next day."
    send_attendance_summary_mail if @settings.send_attendance_summary?
  end

  def calculate_time_spent
    checkin = @current_attendance.checkin
    checkout = @current_attendance.checkout
    time_spent = ((checkout - checkin) / 60 / 60).round(2)
    time_spent = 8.0 if @approved_wfh_requests&.any? && time_spent > 8.0
    time_spent
  end

  def send_attendance_summary_mail
    Attendance::CheckoutNotifierWorker.perform_async(@current_attendance.id, @hours_spent_this_month)
  end

  def send_checkout_reminder(attendance)
    # Work day have 8 * 60 = 480 minutes
    reminding_time = (480 - @settings.checkout_reminder_minutes).minutes.from_now

    return unless @settings.send_checkout_reminder?

    Attendance::CheckoutReminderWorker.perform_in(reminding_time,
                                                  attendance.id,
                                                  hmac_secret,
                                                  @settings.checkout_reminder_minutes)
  end

  def postpone_reminder
    time = params[:time].to_datetime
    time_eg = DateTime.new(time.year, time.month, time.day,
                           time.hour, time.minute, time.second, 'EET')
    Attendance::CheckoutReminderWorker.perform_at(time_eg, @current_attendance.id, hmac_secret, @settings.checkout_reminder_minutes)
  end

  def set_date_ranges
    set_selected_date_range

    if @date_from && @date_to
      if @date_to < @date_from
        flash[:danger] = 'End date cannot be before start date'
        return redirect_to reports_admin_attendances_path
      else
        @date_range = @date_from..@date_to
      end
    end

    set_last_month_date_range
  end

  def set_selected_date_range
    @date_from = params[:from]&.to_datetime&.at_beginning_of_day
    @date_to = params[:to]&.to_datetime&.at_end_of_day
    @current_month_sym = @date_from&.strftime('%b')
  end

  def set_last_month_date_range
    @ex_date_from = @date_from - 1.month if @date_from
    @ex_date_to = @date_to - 1.month if @date_to
    @last_month_sym = @ex_date_from&.strftime('%b')
    @ex_date_range = @ex_date_from..@ex_date_to if @ex_date_from && @ex_date_to
  end

  def set_workdays
    @work_days = @date_range.map { |d| d unless %w[Fri Sat].include?(d.strftime('%a')) }.uniq - [nil] if @date_range
  end

  def set_holidays
    @holidays = Holiday.where(starts_on: @date_from..@date_to)&.pluck(:duration)&.inject(:+) || 0
  end

  def set_reports_entities
    @resource = params[:type].constantize.find_by(id: params[:id]) if params[:type] && params[:id]
  end

  def set_attendances_and_vacations
    @attendances = @resource.attendances.where(checkin: @date_range)
    @ex_attendances = @resource.attendances.where(checkin: @ex_date_range)
    @vacation_requests = @resource.vacation_requests.where(starts_on: @date_range).approved
  end

  def set_actual_vacations
    @work_from_home_days = @vacation_requests.work_from_home.pluck(:duration).inject(:+) || 0
    @vacation_days = @vacation_requests.vacation.pluck(:duration).inject(:+) || 0
    @sick_leave_days = @vacation_requests.sick_leave.pluck(:duration).inject(:+) || 0
  end

  def set_actual_work_days_and_hours
    if @attendances&.any?
      calculate_work_days_and_hours
    elsif params[:from].present? && params[:to].present?
      flash[:danger] = 'This employee has no attendances during the selected dates'
    end
  end

  def calculate_work_days_and_hours
    @actual_work_days = @attendances.size - @attendances.where(checkout: nil).size
    @actual_work_hours = @attendances.pluck(:time_spent)&.inject(:+)&.round(2)
  end

  def set_total_work_days_and_hours
    return unless @work_days
    @total_work_days = @work_days.size - @holidays - @vacation_days - @sick_leave_days
    @total_work_hours = @total_work_days * 8
  end

  def set_messages
    @messages = {
      checkin: [
        'Have you attended twice ?',
        'Are you ok dear ?',
        'Looks like you forgot your coffee!',
        'Didn\'t you hear any welcomes today ?',
        'Refresh your memory!',
        'Maybe you need a break ?',
        'Don\'t worry, we have an excellent memory.',
        'Why do you insist ?'
      ],
      checkout: [
        'I\'m sure!',
        'Looks like you had a long day.',
        'Haven\'t you take your break ?',
        'You can count on us.',
        'And you did great today!',
        'Go home safe.',
        'We need you refreshed tomorrow!',
        'Why do you insist ?'
      ]
    }
  end

  def hmac_secret
    ENV['HMAC_SECRET']
  end

  def token_expired
    case action_name
    when 'remote_checkout'
      redirect_to remote_checkout_admin_attendances_path(error: 2)
    when 'postpone_checkout_reminder'
      redirect_to postpone_checkout_reminder_admin_attendances_path(error: 2)
    end
  end

  def resolve_layout
    case action_name
    when 'remote_checkout', 'postpone_checkout_reminder'
      'remote_checkout'
    else
      'dashboard'
    end
  end
end
