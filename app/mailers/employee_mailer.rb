class EmployeeMailer < ApplicationMailer

  def welcome(employee)
    @employee = employee
    mail(to: @employee.email, subject: 'Welcome to Fustany')
  end
end
