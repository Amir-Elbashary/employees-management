class Admin::HrsController < Admin::BaseAdminController
  load_and_authorize_resource

  def new; end

  def create
    if @hr.save
      flash[:notice] = "#{@hr.full_name} has joined Fustany Team."
      redirect_to admin_hrs_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @hr.update(hr_params)
      flash[:notice] = 'H.R has been successfully updated.'
      redirect_to admin_hrs_path
    else
      render :edit
    end
  end

  def index; end

  def destroy
    return unless @hr.destroy
    flash[:notice] = 'H.R was removed from Fustany Team.'
    redirect_to admin_hrs_path
  end

  private

  def hr_params
    params.require(:hr).permit(:email, :password, :password_confirmation,
                                       :first_name, :last_name, :avatar)
  end
end
