class Admin::RolesController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_permissions, only: %i[new edit]
  before_action :set_hrs, only: %i[new edit]

  def new; end

  def create
    if @role.save
      flash[:notice] = 'Role has been successfully added.'
      redirect_to admin_roles_path
    else
      render :new
    end
  end

  def edit; end

  def update
    if @role.update(role_params)
      flash[:notice] = 'Role has been successfully updated.'
      redirect_to admin_roles_path
    else
      render :edit
    end
  end

  def destroy
    return unless @role.destroy
    flash[:notice] = 'Role was deleted.'
    redirect_to admin_roles_path
  end

  def index; end

  private

  def role_params
    params.require(:role).permit(:name, permission_ids: [], hr_ids: [])
  end

  def set_permissions
    @permissions = Permission.all
  end

  def set_hrs
    @hrs = Hr.all
  end
end
