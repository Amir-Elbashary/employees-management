class Employee::WelcomeWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(employee_id)
    EmployeeMailer.welcome(employee_id).deliver
  end
end
