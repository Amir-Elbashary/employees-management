# Preview all emails at http://localhost:3000/rails/mailers/attendance_mailer
class AttendanceMailerPreview < ActionMailer::Preview

  def checkout_notifier_preview
    @attendance = Attendance.first.id
    @time_spent_this_month = 8
    AttendanceMailer.checkout_notifier(@attendance, @time_spent_this_month)
  end

  def checkout_reminder_preview
    @attendance = Attendance.first.id
    @allowed_time = Setting.first.checkout_reminder_minutes
    AttendanceMailer.checkout_reminder(@attendance, ENV['HMAC_SECRET'], @allowed_time)
  end
end
