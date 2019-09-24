class Admin::TimelinesController < Admin::BaseAdminController
  load_and_authorize_resource

  def create
    if @timeline.save
      set_timeline_type(@timeline)
      flash[:notice] = 'Your post has been published on the timeline'
    else
      flash[:danger] = @timeline.errors.full_messages.join(', ')
    end
    redirect_to admin_path
  end

  def destroy
    return unless @timeline.destroy
    flash[:notice] = 'Your post was deleted'
    redirect_to admin_path
  end

  private

  def timeline_params
    params.require(:timeline).permit(:admin_id, :hr_id, :employee_id, :content, :kind, images:[])
  end

  def set_timeline_type(timeline)
    if params[:timeline][:images].present?
      if params[:timeline][:images].size > 1
        timeline.show_off!
      else
        timeline.news!
      end
    else
      timeline.status!
    end
  end
end
