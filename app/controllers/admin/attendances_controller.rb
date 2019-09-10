class Admin::AttendancesController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource only: %i[index grant revoke]
  before_action :set_attendances, only: :index
  before_action :set_employee, only: %i[grant revoke]

  def index
    if current_employee.access_token != 'expired' && current_employee.listening?
      cookies[:ft_att_ver] = { value: current_employee.access_token, expires: 60.seconds }
      current_employee.exists!
    end
  end

  def grant
    return unless @employee.access_token == 'expired'
    return unless @employee.update(access_token: SecureRandom.hex)
    flash[:notice] = "#{@employee.full_name} access has been granted."
    redirect_to admin_employees_path
  end

  def revoke
    return unless @employee.update(access_token: 'expired', access_token_status: 'listening')
    flash[:notice] = "#{@employee.full_name} access has been revoked."
    redirect_to admin_employees_path
  end

  private

  def set_attendances
    @attendances = current_employee.attendances
  end

  def set_employee
    @employee = Employee.find(params[:id])
  end
end
