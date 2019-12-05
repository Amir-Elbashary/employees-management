class Attendance::CheckoutReminderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(attendance_id, hmac_secret)
    AttendanceMailer.checkout_reminder(attendance_id, hmac_secret).deliver
  end
end
