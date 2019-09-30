class AddMiddleNameToAdminsHrsAndEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :middle_name, :string
    add_column :hrs, :middle_name, :string
    add_column :employees, :middle_name, :string
  end
end
