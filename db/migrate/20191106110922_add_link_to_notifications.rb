class AddLinkToNotifications < ActiveRecord::Migration[5.2]
  def change
    add_column :notifications, :link, :string
  end
end
