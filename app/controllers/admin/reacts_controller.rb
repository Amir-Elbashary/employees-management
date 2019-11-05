class Admin::ReactsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_timeline

  def toggle
    action = params[:react]
    react = @timeline.reacts.where(reactor: current_active_user).first

    if react && react.react == action
      react.destroy
    elsif react && react.react != action
      react.update(react: action)
    else
      React.create(timeline: @timeline, reactor: current_active_user, react: action)
    end
  end

  private

  def set_timeline
    @timeline = Timeline.find(params[:timeline_id])
  end
end
