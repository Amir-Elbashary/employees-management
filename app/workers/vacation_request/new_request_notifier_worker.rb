class VacationRequest::NewRequestNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(vacation_request_id)
    VacationRequestMailer.new_request_notifier(vacation_request_id).deliver
  end
end
