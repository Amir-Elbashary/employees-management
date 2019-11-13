class TimelineMailer < ApplicationMailer

  def new_post_notifier(timeline_id)
    @timeline = Timeline.find(timeline_id)
    mail(to: Employee.pluck(:email), subject: "#{@timeline.publisher.name} posted on Fustany Team timeline")
  end
end
