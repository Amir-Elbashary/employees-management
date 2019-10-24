class MessageMailer < ApplicationMailer

  def new_msg_notifier(message_id)
    @message = Message.find(message_id)
    mail(to: @message.recipient.email, subject: 'Mail Received on Fustany Team')
  end
end
