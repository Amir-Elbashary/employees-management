class Notification::NotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(notification_id)
    notification = Notification.find(notification_id)
    NotificationChannel.broadcast_to('general', notification)
  end
end
