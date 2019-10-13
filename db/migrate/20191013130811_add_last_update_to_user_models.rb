class AddLastUpdateToUserModels < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :last_update, :float, default: 0
    add_column :hrs, :last_update, :float, default: 0
    add_column :employees, :last_update, :float, default: 0
  end
end
