class Timeline::MailNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(timeline_id)
    TimelineMailer.new_post_notifier(timeline_id).deliver
  end
end
