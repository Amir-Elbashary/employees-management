class CreateRolePermissions < ActiveRecord::Migration[5.2]
  def change
    create_table :role_permissions do |t|
      t.references :role, index: true, foreign_key: true
      t.references :permission, index: true, foreign_key: true
    end
  end
end
