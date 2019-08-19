class Admin::EmployeesController < Admin::BaseAdminController
  load_and_authorize_resource

  def new; end

  def create
    if @employee.save
      flash[:notice] = "#{@employee.full_name} has joined Fustany Team."
      redirect_to admin_employees_path
    else
      render :new
    end
  end

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
    flash[:notice] = 'Employee was removed from Fustany Team.'
    redirect_to admin_employees_path
  end

  private

  def employee_params
    params.require(:employee).permit(:email, :password, :password_confirmation, :first_name, :last_name)
  end
end
