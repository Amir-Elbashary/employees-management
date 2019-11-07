class CreateReacts < ActiveRecord::Migration[5.2]
  def change
    create_table :reacts do |t|
      t.references :timeline, index: true, foreign_key: true
      t.references :reactor, polymorphic: true
      t.integer :react, default: 0

      t.timestamps
    end

    add_index :reacts, :react
  end
end
