class VacationRequest::EscalationNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(vacation_request_id)
    VacationRequestMailer.escalation_notifier(vacation_request_id).deliver
  end
end
