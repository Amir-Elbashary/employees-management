class Message::MailNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(message_id)
    MessageMailer.new_msg_notifier(message_id).deliver
  end
end
