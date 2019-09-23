class Admin::RecruitmentsController < Admin::BaseAdminController
  load_and_authorize_resource

  def new; end

  def create
    if @recruitment.save
      flash[:notice] = "#{@recruitment.full_name} has been added to our recruitments list."
      redirect_to admin_recruitments_path
    else
      render :new
    end
  end

  def index; end

  def edit; end

  def update
    if @recruitment.update(recruitment_params)
      flash[:notice] = 'Recruitment has been successfully updated.'
      redirect_to admin_recruitments_path
    else
      render :edit
    end
  end

  def show; end

  def destroy
    return unless @recruitment.destroy
    flash[:notice] = 'Recruitment was deleted.'
    redirect_to admin_recruitments_path
  end

  private

  def recruitment_params
    params.require(:recruitment).permit(:first_name, :last_name, :email, :mobile_number,
                                        :landline_number, :position, :feedback, :decision, :cv)
  end
end
