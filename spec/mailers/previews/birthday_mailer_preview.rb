# Preview all emails at http://localhost:3000/rails/mailers/birthday_mailer
class BirthdayMailerPreview < ActionMailer::Preview

  def mail_notifier_preview
    @employee = Employee.first.id
    BirthdayMailer.mail_notifier(@employee)
  end
end
