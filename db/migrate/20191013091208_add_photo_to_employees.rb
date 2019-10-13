class AddPhotoToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :photo, :string
  end
end
