# Preview all emails at http://localhost:3000/rails/mailers/employee_mailer
class MessageMailerPreview < ActionMailer::Preview

  def new_msg_notifier_preview
    @message = Message.first.id
    MessageMailer.new_msg_notifier(@message)
  end
end
