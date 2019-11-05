class CreateReacts < ActiveRecord::Migration[5.2]
  def change
    create_table :reacts do |t|
      t.references :timeline, index: true, foreign_key: true
      t.references :reactor, polymorphic: true

      t.timestamps
    end
  end
end
