class HolidayMailer < ApplicationMailer

  def new_holiday_notifier(holiday_id)
    @holiday = Holiday.find(holiday_id)
    mail(to: Employee.pluck(:email), subject: @holiday.name)
  end
end
