class Admin::NotificationsController < Admin::BaseAdminController
  load_and_authorize_resource
  skip_load_resource
  before_action :set_user, only: %i[index toggle_all_read_status]
  before_action :set_notifications, only: %i[index toggle_all_read_status]
  before_action :set_notification, only: :toggle_read_status

  def create
    Notification::GeneralNotificationWorker.perform_async(params[:notification][:content])
  end

  def index;end

  def toggle_read_status
    if @notification.unread?
      @notification.read!
    else
      @notification.unread!
    end
  end

  def toggle_all_read_status
    @notifications.each { |n| n.read! }
    redirect_to request.referer
  end

  private

  def notification_params
    params.require(:notification).permit(:content)
  end

  def set_user
    user_data = params[:user].split('-')
    user_model = user_data.first.capitalize.constantize
    user_id = user_data.last

    @user = user_model.find(user_id)
    redirect_to admin_path if @user != current_active_user
  end

  def set_notifications
    @notifications = @user.notifications
  end

  def set_notification
    @notification = Notification.find(params[:id])
  end
end
