class Admin::UpdatesController < Admin::BaseAdminController
  load_and_authorize_resource

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

  private

  def update_params
    params.require(:update).permit(:version, :changelog, images:[])
  end

  def create_timeline_post(content)
    Timeline.create(employee: current_employee,
                    images: [],
                    kind: 'news',
                    creation: 'manual',
                    content: content)
  end
end
