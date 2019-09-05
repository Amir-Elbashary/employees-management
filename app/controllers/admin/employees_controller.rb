class Admin::EmployeesController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_sections, except: %i[index destroy]
  before_action :build_documents, only: %i[new edit]

  def new; end

  def create
    if @employee.save
      flash[:notice] = "#{@employee.full_name} has joined Fustany Team."
      redirect_to admin_employees_path
      Mail::WelcomeWorker.perform_async(@employee.id)
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

  def show; end

  def destroy
    return unless @employee.destroy
    flash[:notice] = 'Employee was removed from Fustany Team.'
    redirect_to admin_employees_path
  end

  def toggle_level
    employee = Employee.find(params[:id])

    if employee.supervisor?
      employee.employee!
    else
      employee.supervisor!
    end
  end

  def resend_mail
    Mail::WelcomeWorker.perform_async(@employee.id)
    flash[:notice] = 'Mail sent! it may take sometime based on server load'
    redirect_to admin_employees_path
  end

  private

  def employee_params
    params.require(:employee).permit(:email, :password, :password_confirmation, :first_name, :last_name,
                                     :gender, :birthdate, :address, :social_id, :personal_email, :business_email,
                                     :mobile_numbers, :landline_numbers, :qualification, :graduation_year, :section_id,
                                     :date_of_employment, :job_description, :work_type,
                                     :date_of_social_insurance_joining, :social_insurance_number, :military_status,
                                     :marital_status, :nationality, :vacation_balance,
                                     :avatar, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
                                     :supervisor_id, :salary, :bank_account,
                                     documents_attributes: %i[id name file _destroy])
  end

  def set_sections
    @sections = Section.roots.sort
  end

  def build_documents
    @employee.documents.build
  end
end
