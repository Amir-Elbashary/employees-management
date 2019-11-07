class Comment::MailNotifierWorker
  include Sidekiq::Worker
  sidekiq_options queue: 'default'

  def perform(comment_id)
    CommentMailer.new_comment_notifier(comment_id).deliver
  end
end
