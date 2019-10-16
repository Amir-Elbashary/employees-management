class AddReadStatusToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :read_status, :integer, default: 0
    add_index :notifications, :read_status
  end
end
