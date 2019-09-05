class EmployeeMailer < ApplicationMailer

  def welcome(employee_id)
    @employee = Employee.find(employee_id)
    mail(to: @employee.email, subject: 'Welcome to Fustany')
  end
end
