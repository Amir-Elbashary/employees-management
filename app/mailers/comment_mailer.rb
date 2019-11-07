class CommentMailer < ApplicationMailer

  def new_comment_notifier(comment_id)
    @comment = Comment.find(comment_id)
    mail(to: @comment.timeline.owner.email, subject: "#{@comment.owner.name} commented on your post")
  end
end
