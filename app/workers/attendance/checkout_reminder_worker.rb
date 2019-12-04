class Attendance::CheckoutReminderWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(attendance_id)
    AttendanceMailer.checkout_reminder(attendance_id).deliver
  end
end
