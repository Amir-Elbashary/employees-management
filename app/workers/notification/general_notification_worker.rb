class Notification::GeneralNotificationWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(content)
    [Admin, Hr, Employee].map do |model|
      model.all.each do |user|
        notification = Notification.create(content: content, recipient: user)
        NotificationChannel.broadcast_to('general', notification)
      end
    end
  end
end
