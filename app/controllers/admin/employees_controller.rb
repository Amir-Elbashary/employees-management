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
      if params[:employee][:avatar].present?
        render :crop ## Render the view for cropping
      else
        redirect_to admin_employees_path
      end
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
    params.require(:employee).permit(:email, :password, :password_confirmation, :first_name, :last_name,
                                     :gender, :birthdate, :address, :social_id, :personal_email, :business_email,
                                     :mobile_numbers, :landline_numbers, :qualification, :graduation_year,
                                     :date_of_employment, :job_description, :work_type, :date_of_social_insurance_joining,
                                     :social_insurance_number, :military_status, :marital_status, :nationality, :vacation_balance,
                                     :avatar, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h)
  end
end
