# Preview all emails at http://localhost:3000/rails/mailers/timeline_mailer
class TimelineMailerPreview < ActionMailer::Preview

  def new_post_notifier_preview
    @timeline = Employee.first.timelines.first
    TimelineMailer.new_post_notifier(@timeline.id)
  end
end
