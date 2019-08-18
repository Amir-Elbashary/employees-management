class Admin::UsersController < Admin::BaseAdminController
  load_and_authorize_resource

  def index; end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:notice] = 'User has been successfully updated.'
      redirect_to admin_users_path
    else
      render :edit
    end
  end

  def destroy
    return unless @user.destroy
    flash[:notice] = 'User was deleted'
    redirect_to admin_users_path
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :experience, :avg_price, :avg_duration)
  end
end
