class VacationRequest::HrPendingApproveNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(vacation_request_id)
    VacationRequestMailer.hr_pending_approve_notifier(vacation_request_id).deliver
  end
end
