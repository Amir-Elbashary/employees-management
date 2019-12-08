class AttendanceMailer < ApplicationMailer

  def checkout_notifier(attendance_id, time_spent_this_month)
    find_attendance(attendance_id)
    @time_spent_this_month = time_spent_this_month + @attendance.time_spent
    mail(to: @attendance.attender.email,
         subject: "Attendance summary for #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end

  def checkout_reminder(attendance_id, hmac_secret, minutes_before_leaving)
    @allowed_minutes = minutes_before_leaving
    find_attendance(attendance_id)

    generate_token(@attendance, hmac_secret, @allowed_minutes)

    mail(to: @attendance.attender.email,
         subject: "Checkout reminder for today #{@attendance.checkin.strftime('%A %d %B %Y')}")
  end

  private

  def find_attendance(attendance_id)
    @attendance = Attendance.find(attendance_id)
  end

  def generate_token(attendance, hmac_secret, allowed_time)
    payload = {
      attendance_id: attendance.id,
      attender_type: attendance.attender_type,
      attender_id: attendance.attender_id,
      exp: (Time.zone.now + allowed_time.minutes).to_i
    }

    @token = JWT.encode(payload, hmac_secret, 'HS256')
  end
end
