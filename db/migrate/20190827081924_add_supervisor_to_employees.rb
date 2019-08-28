class AddSupervisorToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :supervisor_id, :integer
    add_index :employees, :supervisor_id
  end
end
