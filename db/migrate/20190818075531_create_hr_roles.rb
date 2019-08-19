class CreateHrRoles < ActiveRecord::Migration[5.2]
  def change
    create_table :hr_roles do |t|
      t.references :hr, index: true, foreign_key: true
      t.references :role, index: true, foreign_key: true
    end
  end
end
