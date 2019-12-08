class Attendance::CheckoutReminderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(attendance_id, hmac_secret, minutes_before_leaving)
    AttendanceMailer.checkout_reminder(attendance_id, hmac_secret, minutes_before_leaving).deliver
  end
end
