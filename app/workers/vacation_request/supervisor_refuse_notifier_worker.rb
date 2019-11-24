class VacationRequest::SupervisorRefuseNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(vacation_request_id)
    VacationRequestMailer.supervisor_refuse_notifier(vacation_request_id).deliver
  end
end
