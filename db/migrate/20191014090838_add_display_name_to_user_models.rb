class AddDisplayNameToUserModels < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :display_name, :string
    add_column :hrs, :display_name, :string
    add_column :employees, :display_name, :string
  end
end
