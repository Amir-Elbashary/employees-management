class AddAccessTokenStatusToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :access_token_status, :integer, default: 0
  end
end
