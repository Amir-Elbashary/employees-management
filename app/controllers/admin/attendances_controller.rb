class Admin::AttendancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: %i[index grant revoke]
  before_action :require_authorized_network, only: %i[checkin checkout]
  before_action :require_authorized_device, only: %i[checkin checkout]
  before_action :set_attendances, only: :index
  before_action :set_employees, only: :reports
  before_action :set_employee, only: %i[grant revoke]
  before_action :set_messages, only: %i[checkin checkout]

  def index
    return unless current_employee
    if current_employee.access_token != 'expired' && current_employee.waiting_for_token?
      cookies[:ft_att_ver] = { value: current_employee.access_token, expires: 1.year }
      current_employee.token_verified!
    end
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
      if current_admin
        Attendance.create(admin: current_admin, checkin: Time.zone.now)
      elsif current_hr
        Attendance.create(hr: current_hr, checkin: Time.zone.now)
      elsif current_employee
        Attendance.create(employee: current_employee, checkin: Time.zone.now)
      end
      flash[:notice] = "Thank you #{current_active_user.first_name}, Wishing you good and productive day."
    end

    redirect_to request.referer
  end

  def checkout
    if @current_attendance&.checkout
      flash[:notice] = "You have already checked-out today, #{@messages[:checkout].sample}"
    else
      if @current_attendance&.update(checkout: Time.zone.now)
        checkin = @current_attendance.checkin
        checkout = @current_attendance.checkout
        time_spent = ((checkout - checkin) / 60 / 60).round(2)
        @current_attendance.update(time_spent: time_spent)
        flash[:notice] = "Thanks #{current_active_user.first_name}, See you next day."
      else
        flash[:danger] = 'You haven\'t check-in today yet, Let\'s start a productive day!'
      end
    end

    redirect_to request.referer
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
    employee = Employee.find(params[:employee])
    checktime = params[:checktime].to_datetime
    checktime_utc = DateTime.new(checktime.year, checktime.month, checktime.day, checktime.hour, checktime.minute, checktime.second, 'EET').utc
    check_type = params[:check_type]
    attendance = employee.attendances&.where(checkin: checktime_utc.at_beginning_of_day..checktime_utc.at_end_of_day)&.first

    if check_type == 'Check-in'
      if attendance
        flash[:danger] = 'Employee already checked-in'
      else
        flash[:notice] = 'Check-in appended'
        Attendance.create(employee: employee, checkin: checktime_utc)
      end
    elsif check_type == 'Check-out'
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

    redirect_to admin_attendances_path
  end

  def reports
    # Current month date range
    date_from = params[:from]&.to_datetime&.at_beginning_of_day
    date_to = params[:to]&.to_datetime&.at_end_of_day
    @current_month_sym = date_from&.strftime('%b')

    if date_from && date_to
      if date_to < date_from
        flash[:danger] = 'End date cannot be before start date'
        return redirect_to reports_admin_attendances_path
      else
        date_range = date_from..date_to
      end
    end

    # Last month (ex) date range
    ex_date_from = date_from - 1.month if date_from
    ex_date_to = date_to - 1.month if date_to
    @last_month_sym = ex_date_from&.strftime('%b')
    ex_date_range = ex_date_from..ex_date_to if ex_date_from && ex_date_to

    @work_days = date_range.map { |d| d unless ['Fri', 'Sat'].include?(d.strftime('%a'))}.uniq - [nil] if date_range

    @holidays = Holiday.where(starts_on: date_from..date_to)&.pluck(:duration)&.inject(:+) || 0

    @employee = Employee.find_by(id: params[:employee]) if params[:employee]

    if @employee
      @attendances = @employee.attendances.where(checkin: date_range)
      @ex_attendances = @employee.attendances.where(checkin: ex_date_range)
      @vacation_requests = @employee.vacation_requests.where(starts_on: date_range).approved
    end

    # Variables needed for views calculations
    if @work_days
      @total_work_days = @work_days.size - @holidays
      @total_work_hours = (@work_days.size * 8) - (@holidays * 8)
    end
    if @attendances.any?
      @actual_work_days = @attendances.size
      @actual_work_hours = @attendances.pluck(:time_spent)&.inject(:+)&.round(2)
    else
      if params[:from].present? && params[:to].present?
        flash[:danger] = 'This employee has no attendances during the selected dates'
      end
    end
    if @vacation_requests
      @work_from_home_days = @vacation_requests.work_from_home.size
      @vacation_days = @vacation_requests.vacation.size
      @sick_leave_days = @vacation_requests.sick_leave.size
    end
  end

  private

  def require_authorized_network
    return if @approved_requests&.any?
    return unless current_employee
    return if @settings.ip_addresses[0]&.split(',')&.include?(request.remote_ip)
    flash[:danger] = 'Unauthorized network detected, Please connect to an authorized network!'
    redirect_to admin_path
  end

  def require_authorized_device
    return unless current_employee
    return if cookies[:ft_att_ver] == current_employee.access_token
    flash[:danger] = 'Unauthorized device detected, Please connect via an authorized device!'
    redirect_to admin_path
  end

  def set_attendances
    @employees = Employee.all unless current_employee
    @attendance = Attendance.new
    @attendances = if current_employee
                     current_employee.attendances
                   elsif current_admin || current_hr
                     Attendance.all
                   end
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end

  def set_employees
    @employees = Employee.all
  end

  def set_messages
    @messages = { checkin: [
                    'Have you attended twice?',
                    'Are you ok dear ?',
                    'Looks like you forgot your coffee!',
                    'Didn\'t you hear any welcomes today ?',
                    'Refresh your memory!',
                    'Maybe you need a break?',
                    'Don\'t worry, we have an excellent memory.',
                    'Why do you insist ?'
                  ],
                  checkout: [
                    'I\'m sure!',
                    'Looks like you had a long day.',
                    'Haven\'t you take your break?',
                    'You can count on us.',
                    'And you did great today!',
                    'Go home safe.',
                    'We need you refreshed tomorrow!',
                    'Why do you insist ?'
                  ]
                }
  end
end
