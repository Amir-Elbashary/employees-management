class Admin::UpdatesController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_settings, only: :reset_ip

  def create
    if @update.save
      flash[:notice] = 'Update has been announced.'
      redirect_to admin_updates_path
    else
      render 'new'
    end

    create_timeline_post(@update.changelog) if params[:update][:announce]
  end

  def update
    if @update.update(update_params)
      flash[:notice] = 'Changes has been saved'
      redirect_to admin_updates_path
    else
      render 'edit'
    end

    create_timeline_post(@update.changelog) if params[:update][:announce]
  end

  def index; end

  def destroy
    return unless @update.destroy
    flash[:notice] = 'Update has been delayed.'
    redirect_to admin_updates_path
  end

  def reset_ip
    if @settings.update(ip_addresses: (@settings.ip_addresses << request.remote_ip).uniq)
      flash[:notice] = 'IP Address has been successfully appended'
    else
      flash[:danger] = 'There was an error, Please try again later'
    end

    redirect_to admin_path
  end

  private

  def update_params
    params.require(:update).permit(:version, :changelog, images: [])
  end

  def set_settings
    @settings = Setting.first
  end

  def create_timeline_post(content)
    Timeline.create(publisher: current_employee,
                    images: [],
                    kind: 'news',
                    creation: 'manual',
                    content: content)
  end
end
