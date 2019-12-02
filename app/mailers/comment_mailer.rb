class CommentMailer < ApplicationMailer

  def new_comment_notifier(comment_id)
    @comment = Comment.find(comment_id)
    mail(to: @comment.timeline.publisher.email,
         subject: "#{@comment.commenter.name} commented on your post")
  end
end
