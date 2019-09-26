class Timeline::TimelineWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(timeline_id)
    timeline = Timeline.find(timeline_id)
    TimelineChannel.broadcast_to('public', timeline)
  end
end
