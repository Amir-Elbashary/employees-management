class AttendanceMailer < ApplicationMailer

  def checkout_notifier(attendance_id, time_spent_this_month)
    @attendance = Attendance.find(attendance_id)
    @time_spent_this_month = time_spent_this_month + @attendance.time_spent
    mail(to: @attendance.attender.email,
         subject: "Attendance summary for #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end

  def checkout_reminder(attendance_id, hmac_secret)
    @attendance = Attendance.find(attendance_id)

    payload = {
      attendance_id: @attendance.id,
      attender_type: @attendance.attender_type,
      attender_id: @attendance.attender_id,
      exp: (Time.zone.now + 5.minutes).to_i
    }

    @token = JWT.encode(payload, hmac_secret, 'HS256')

    mail(to: @attendance.attender.email,
         subject: "Checkout reminder for today #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end
end
