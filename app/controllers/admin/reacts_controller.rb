class Admin::ReactsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_timeline

  def toggle
    react = @timeline.reacts.where(reactor: current_active_user).first
    if react
      react.destroy
    else
      React.create(timeline: @timeline, reactor: current_active_user)
    end
  end

  private

  def set_timeline
    @timeline = Timeline.find(params[:timeline_id])
  end
end
