class AddAccessTokenToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :access_token, :string
  end
end
