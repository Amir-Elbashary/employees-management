class Employee::BirthdayMailNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(employee_id)
    BirthdayMailer.mail_notifier(employee_id).deliver
  end
end
