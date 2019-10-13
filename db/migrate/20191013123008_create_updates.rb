class CreateUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :updates do |t|
      t.float :version
      t.text :changelog
      t.string :images, array: true, default: []

      t.timestamps
    end
  end
end
