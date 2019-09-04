class AddSalaryAndBankAccNumToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :salary, :integer, default: 0
    add_column :employees, :bank_account, :string
  end
end
