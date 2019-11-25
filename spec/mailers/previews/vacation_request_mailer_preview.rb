# Preview all emails at http://localhost:3000/rails/mailers/vacation_request_mailer
class VacationRequestMailerPreview < ActionMailer::Preview

  def new_request_notifier_previewe
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.new_request_notifier(@vacation_request)
  end

  def supervisor_confirm_notifier_preview
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.supervisor_confirm_notifier(@vacation_request)
  end

  def supervisor_refuse_notifier_preview
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.supervisor_refuse_notifier(@vacation_request)
  end

  def hr_pending_approve_notifier_preview
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.hr_pending_approve_notifier(@vacation_request)
  end

  def hr_approve_notifier_preview
    @hr = Hr.first.id
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.hr_approve_notifier(@hr, @vacation_request)
  end

  def hr_decline_notifier_preview
    @hr = Hr.first.id
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.hr_decline_notifier(@hr, @vacation_request)
  end

  def escalation_notifier_preview
    @vacation_request = VacationRequest.first.id
    VacationRequestMailer.escalation_notifier(@vacation_request)
  end
end
