class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_for 'general'
  end

  def unsubscribed
    stop_all_streams           
  end
end
