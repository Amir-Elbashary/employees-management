class AddSectionToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_reference :employees, :section, foreign_key: true
  end
end
