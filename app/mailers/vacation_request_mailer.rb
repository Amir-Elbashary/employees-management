class VacationRequestMailer < ApplicationMailer

  def new_request_notifier(vacation_request_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    mail(to: @vacation_request.requester.supervisor.email, subject: "#{@vacation_request.requester.full_name} has a new #{@vacation_request.kind.humanize.downcase} request")
  end

  def supervisor_confirm_notifier(vacation_request_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    mail(to: @vacation_request.requester.email, subject: "#{@vacation_request.requester.supervisor.full_name} has confirmed your request")
  end

  def supervisor_refuse_notifier(vacation_request_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    mail(to: @vacation_request.requester.email, subject: "#{@vacation_request.requester.supervisor.full_name} has refused your request")
  end

  def hr_approve_notifier(hr_id, vacation_request_id)
    @hr = Hr.find(hr_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    @vacation_balance = @vacation_request.requester.vacation_balance
    mail(to: @vacation_request.requester.email, subject: "#{@hr.full_name} has approved your request")
  end

  def hr_decline_notifier(hr_id, vacation_request_id)
    @hr = Hr.find(hr_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    mail(to: @vacation_request.requester.email, subject: "#{@hr.full_name} has declined your request")
  end

  def escalation_notifier(vacation_request_id)
    @vacation_request = VacationRequest.find(vacation_request_id)
    mail(to: Hr.pluck(:email), subject: "#{@vacation_request.requester.full_name} has escalated a request")
  end
end
