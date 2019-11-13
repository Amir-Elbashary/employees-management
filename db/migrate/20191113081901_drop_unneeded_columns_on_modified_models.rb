class DropUnneededColumnsOnModifiedModels < ActiveRecord::Migration[5.2]
  def change
    remove_index :attendances, :admin_id
    remove_index :attendances, :hr_id
    remove_index :attendances, :employee_id
    remove_column :attendances, :admin_id
    remove_column :attendances, :hr_id
    remove_column :attendances, :employee_id

    remove_index :comments, :admin_id
    remove_index :comments, :hr_id
    remove_index :comments, :employee_id
    remove_column :comments, :admin_id
    remove_column :comments, :hr_id
    remove_column :comments, :employee_id

    remove_index :timelines, :admin_id
    remove_index :timelines, :hr_id
    remove_index :timelines, :employee_id
    remove_column :timelines, :admin_id
    remove_column :timelines, :hr_id
    remove_column :timelines, :employee_id

    remove_index :vacation_requests, :employee_id
    remove_column :vacation_requests, :employee_id
  end
end
