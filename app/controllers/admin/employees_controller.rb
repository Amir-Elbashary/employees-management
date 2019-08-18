class Admin::EmployeesController < Admin::BaseAdminController
  load_and_authorize_resource

  def index; end

  def edit; end

  def update
    if @employee.update(employee_params)
      flash[:notice] = 'Employee has been successfully updated.'
      redirect_to admin_employees_path
    else
      render :edit
    end
  end

  def destroy
    return unless @employee.destroy
    flash[:notice] = 'Employee was deleted'
    redirect_to admin_employees_path
  end

  private

  def user_params
    params.require(:employee).permit(:first_name, :last_name)
  end
end
