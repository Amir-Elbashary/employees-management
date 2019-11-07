# Preview all emails at http://localhost:3000/rails/mailers/comment_mailer
class CommentMailerPreview < ActionMailer::Preview

  def new_comment_notifier_preview
    @comment = Employee.where(first_name: 'Asmaa').first.id
    CommentMailer.new_comment_notifier(@comment)
  end
end
