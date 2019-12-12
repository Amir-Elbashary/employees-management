class Admin::EmployeesController < Admin::BaseAdminController
  include TimelineHelper
  load_and_authorize_resource
  skip_load_resource only: :birthdays
  before_action :set_employees, only: :compare
  before_action :set_sections, except: %i[index destroy]
  before_action :build_documents, only: %i[new edit]
  before_action :set_birthdays, only: :birthdays

  def new; end

  def create
    if @employee.save
      @employee.update(display_name: @employee.full_name)
      flash[:notice] = "#{@employee.full_name} has joined Fustany Team."
      redirect_to admin_employees_path
      Employee::WelcomeWorker.perform_async(@employee.id)
    else
      render :new
    end
  end

  def index; end

  def compare; end

  def edit; end

  def update
    if @employee.update(employee_params)
      @employee.update(display_name: @employee.full_name) if @employee.display_name.nil?
      flash[:notice] = 'Employee has been successfully updated.'
      redirect_to admin_employees_path
    else
      render :edit
    end
  end

  # With Cropper
  # def update
  #   if @employee.update(employee_params)
  #     flash[:notice] = 'Employee has been successfully updated.'
  #     if params[:employee][:avatar].present?
  #       render :crop ## Render the view for cropping
  #     else
  #       redirect_to admin_employees_path
  #     end
  #   else
  #     render :edit
  #   end
  # end

  def show; end

  def destroy
    return unless @employee.destroy
    flash[:notice] = 'Employee was removed from Fustany Team.'
    redirect_to admin_employees_path
  end

  def toggle_state
    if @employee.active?
      @employee.inactive!
    else
      @employee.active!
    end
  end

  def toggle_level
    if @employee.supervisor?
      @employee.employee!
    else
      @employee.supervisor!
    end
  end

  def resend_mail
    Mail::WelcomeWorker.perform_async(@employee.id)
    flash[:notice] = 'Mail sent! it may take sometime based on server load'
    redirect_to admin_employees_path
  end

  def profile; end

  def update_profile
    if @employee.update(employee_params)
      flash[:notice] = 'Profile has been updated'
    else
      flash[:danger] = @employee.errors.full_messages.join(', ')
    end

    redirect_to admin_path
  end

  def birthdays; end

  def announce_birthday
    create_timeline_post(@employee, birthday_post_content)

    flash[:notice] = "You have announced #{@employee.first_name}'s birthday"\
                     ', Timeline post has been created and email was sent.'

    Employee::BirthdayMailNotifierWorker.perform_async(@employee.id)

    redirect_to request.referer
  end

  private

  def employee_params
    params.require(:employee).permit(:email, :password, :password_confirmation, :first_name, :middle_name, :last_name,
                                     :gender, :birthdate, :address, :social_id, :personal_email, :business_email,
                                     :mobile_numbers, :landline_numbers, :qualification, :graduation_year, :section_id,
                                     :date_of_employment, :job_description, :work_type,
                                     :date_of_social_insurance_joining, :social_insurance_number, :military_status,
                                     :marital_status, :nationality, :vacation_balance, :photo,
                                     :avatar, :avatar_crop_x, :avatar_crop_y, :avatar_crop_w, :avatar_crop_h,
                                     :supervisor_id, :salary, :bank_account, :display_name,
                                     documents_attributes: %i[id name file _destroy])
  end

  def set_sections
    @sections = Section.roots.sort
  end

  def set_employees
    @employees = Employee.all
  end

  def build_documents
    @employee.documents.build
  end

  def set_birthdays
    @birthdays = Employee.active.upcoming_birthdays
  end

  def birthday_post_content
    "<h2><strong>:tada: &nbsp; Happiest birthday #{@employee.name} &nbsp; :tada:</strong></h2>
    <h4><strong>May this year be full of joy, happiness
    , health and wealth :heart_eyes:</strong></h4><h4><strong>From your Fustany family
    , we wish you all the best :heart:</strong></h4>"
  end
end
