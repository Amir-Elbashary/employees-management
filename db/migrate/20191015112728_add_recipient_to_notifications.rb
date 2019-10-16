class AddRecipientToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_reference :notifications, :recipient, polymorphic: true
  end
end
