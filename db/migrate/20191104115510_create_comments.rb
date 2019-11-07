class CreateComments < ActiveRecord::Migration[5.2]
  def change
    create_table :comments do |t|
      t.references :timeline, index: true, foreign_key: true
      t.references :admin, index: true, foreign_key: true
      t.references :hr, index: true, foreign_key: true
      t.references :employee, index: true, foreign_key: true
      t.text :content
      t.string :image

      t.timestamps
    end
  end
end
