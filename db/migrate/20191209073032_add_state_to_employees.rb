class AddStateToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :state, :integer, default: 0
    add_index :employees, :state
  end
end
