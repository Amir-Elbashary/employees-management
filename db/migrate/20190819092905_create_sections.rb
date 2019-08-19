class CreateSections < ActiveRecord::Migration[5.2]
  def change
    create_table :sections do |t|
      t.string :name
      t.integer :parent_id, index: true, foreign_key: true
      t.timestamps
    end
  end
end
