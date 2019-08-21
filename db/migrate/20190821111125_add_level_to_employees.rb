class AddLevelToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :level, :integer, default: 0
    add_index :employees, :level
  end
end
