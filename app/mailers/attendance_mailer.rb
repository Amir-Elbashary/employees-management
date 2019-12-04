class AttendanceMailer < ApplicationMailer

  def checkout_notifier(attendance_id, time_spent_this_month)
    @attendance = Attendance.find(attendance_id)
    @time_spent_this_month = time_spent_this_month + @attendance.time_spent
    mail(to: @attendance.attender.email,
         subject: "Attendance summary for #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end

  def checkout_reminder(attendance_id)
    @attendance = Attendance.find(attendance_id)
    mail(to: @attendance.attender.email,
         subject: "Checkout reminder for today #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end
end
