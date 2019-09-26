class Admin::NotificationsController < Admin::BaseAdminController
  load_and_authorize_resource

  def create
    Notification.create(notification_params)
  end

  private

  def notification_params
    params.require(:notification).permit(:content)
  end
end
