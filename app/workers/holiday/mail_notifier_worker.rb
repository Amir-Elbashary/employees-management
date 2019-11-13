class Holiday::MailNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(holiday_id)
    HolidayMailer.new_holiday_notifier(holiday_id).deliver
  end
end
