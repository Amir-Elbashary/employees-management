class Admin::CommentsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource except: :destroy
  before_action :set_timeline

  def create
    @comment = Comment.new(comment_params)
    flash[:danger] = @comment.errors.full_messages.join(', ') unless @comment.save
    redirect_to admin_timeline_path(@timeline)
    create_notifications if @comment.save
  end

  def destroy
    return unless @comment.destroy
    flash[:notice] = 'Comment deleted'
    redirect_to admin_timeline_path(@timeline)
  end

  private

  def comment_params
    params.require(:comment).permit(:timeline_id, :admin_id, :hr_id, :employee_id, :content)
  end

  def set_timeline
    @timeline = Timeline.find(params[:timeline_id])
  end

  def create_notifications
    return if @comment.timeline.owner == current_active_user
    Notification.create(recipient: @comment.timeline.owner,
                        content: "#{@comment.owner.name} commented on your post.",
                        link: "/admin/timelines/#{@comment.timeline.id}")

    Comment::MailNotifierWorker.perform_async(@comment.id)
  end
end
