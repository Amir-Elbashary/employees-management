class BirthdayMailer < ApplicationMailer

  def mail_notifier(employee_id)
    @employee = Employee.find(employee_id)
    mail(to: @employee.email, subject: "Happy Birthday #{@employee.first_name}")
  end
end
