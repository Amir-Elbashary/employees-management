class Admin::RecruitmentsController < Admin::BaseAdminController
  load_and_authorize_resource

  # def new; end

  # def create
  #   if @employee.save
  #     flash[:notice] = "#{@employee.full_name} has joined Fustany Team."
  #     redirect_to admin_employees_path
  #     Mail::WelcomeWorker.perform_async(@employee.id)
  #   else
  #     render :new
  #   end
  # end

  def index; end

  # def edit; end

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

  # def show; end

  # def destroy
  #   return unless @employee.destroy
  #   flash[:notice] = 'Employee was removed from Fustany Team.'
  #   redirect_to admin_employees_path
  # end

  private

  def recruitment_params
    params.require(:recruitment).permit()
  end
end
