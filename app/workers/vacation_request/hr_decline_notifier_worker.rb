class VacationRequest::HrDeclineNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(hr_id, vacation_request_id)
    VacationRequestMailer.hr_decline_notifier(hr_id, vacation_request_id).deliver
  end
end
