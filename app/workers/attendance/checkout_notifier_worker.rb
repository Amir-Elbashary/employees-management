class Attendance::CheckoutNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(attendance_id, time_spent_this_month)
    AttendanceMailer.checkout_notifier(attendance_id, time_spent_this_month).deliver
  end
end
