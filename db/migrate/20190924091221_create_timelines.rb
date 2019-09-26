class CreateTimelines < ActiveRecord::Migration[5.2]
  def change
    create_table :timelines do |t|
      t.references :admin, foreign_key: true
      t.references :hr, foreign_key: true
      t.references :employee, foreign_key: true
      t.text :content 
      t.string :images, array: true, default: []
      t.integer :kind, default: 0

      t.timestamps
    end
  end
end
