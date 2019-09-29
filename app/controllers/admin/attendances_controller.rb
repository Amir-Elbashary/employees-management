class Admin::AttendancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: %i[index grant revoke]
  before_action :set_settings
  before_action :require_authorized_network, except: %i[index grant revoke]
  before_action :require_authorized_device, except: %i[index grant revoke]
  before_action :set_attendances, only: :index
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
        flash[:notice] = "Thanks #{current_active_user.first_name}, Goodbye."
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
    check_type = params[:check_type]
    attendance = employee.attendances&.where(created_at: checktime.at_beginning_of_day..checktime.at_end_of_day)&.first

    if check_type == 'Check-in'
      if attendance
        flash[:danger] = 'Employee already checked-in'
      else
        flash[:notice] = 'Check-in appended'
        Attendance.create(employee: employee, checkin: checktime)
      end
    elsif check_type == 'Check-out'
      if attendance
        if attendance.checkout
          flash[:danger] = 'Employee already checked-out'
        else
          flash[:notice] = 'Check-out appended'
          checkin = attendance.checkin.to_datetime
          time_spent = ((checktime.to_f - checkin.to_f) / 60 / 60).round(2)
          attendance.update(checkout: checktime, time_spent: time_spent)
        end
      else
        flash[:danger] = 'Employee has not checked-in during selected day' 
      end
    end

    redirect_to admin_attendances_path
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

  def set_settings
    @settings = Setting.first
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
