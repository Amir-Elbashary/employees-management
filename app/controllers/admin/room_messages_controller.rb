class Admin::RoomMessagesController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_room, only: :create

  def create
    @room_message.employee = current_active_user
    @room_message.room = @room

    @room_message.save
    RoomChannel.broadcast_to(@room, @room_message)
  end

  private

  def room_message_params
    params.require(:room_message).permit(:message)
  end

  def set_room
    @room = Room.find(params[:room_message][:room_id])
  end
end
