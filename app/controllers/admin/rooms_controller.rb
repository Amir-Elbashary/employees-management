class Admin::RoomsController < Admin::BaseAdminController
  load_and_authorize_resource
  before_action :set_employees, only: :show
  before_action :set_messages, only: :show

  def show; end

  private

  def set_messages
    @room_messages = @room.room_messages.last(40)
    @new_message = RoomMessage.new(room: @room)
  end

  def set_employees
    @employees = Employee.all
  end
end
