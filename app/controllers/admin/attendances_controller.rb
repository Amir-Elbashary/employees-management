class Admin::AttendancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: %i[index grant revoke]
  before_action :set_settings
  before_action :require_authorized_network, except: %i[index grant revoke]
  before_action :set_attendances, only: :index
  before_action :set_employee, only: %i[grant revoke]

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
      flash[:notice] = 'You have already checked-in today'
    else
      Attendance.create(employee: current_employee, checkin: DateTime.now)
      flash[:notice] = "Thank you #{current_employee.first_name}, Wishing you good and productive day."
    end

    redirect_to request.referer
  end

  def checkout
    if @current_attendance.checkout
      flash[:notice] = 'You have already checked-out today'
    else
      if @current_attendance.update(checkout: DateTime.now)
        checkin = @current_attendance.checkin
        checkout = @current_attendance.checkout
        time_spent = ((checkout - checkin) / 60 / 60).round(2)
        @current_attendance.update(time_spent: time_spent)
        flash[:notice] = "Thanks #{current_employee.first_name}, Goodbye."
      else
        flash[:danger] = 'An error occured, Please contact technical team'
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

  private

  def require_authorized_network
    return if @settings.ip_addresses[0]&.split(',')&.include?(request.remote_ip)
    flash[:danger] = 'Unauthorized network detected, Please connect to an authorized network!'
    redirect_to admin_path
  end

  def set_attendances
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
end
