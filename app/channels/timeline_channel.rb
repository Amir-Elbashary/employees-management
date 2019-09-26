class TimelineChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'public'
  end

  def unsubscribed
    stop_all_streams           
  end
end
