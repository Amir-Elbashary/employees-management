# Preview all emails at http://localhost:3000/rails/mailers/holiday_mailer
class HolidayMailerPreview < ActionMailer::Preview

  def new_holiday_notifier_preview
    @holiday = Holiday.first.id
    HolidayMailer.new_holiday_notifier(@holiday)
  end
end
