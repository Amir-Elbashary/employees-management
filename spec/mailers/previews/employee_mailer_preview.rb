# Preview all emails at http://localhost:3000/rails/mailers/employee_mailer
class EmployeeMailerPreview < ActionMailer::Preview

  def welcome_preview
    @employee = Employee.first
    EmployeeMailer.welcome(@employee)
  end
end
