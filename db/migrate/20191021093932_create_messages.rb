class CreateMessages < ActiveRecord::Migration[5.2]
  def change
    create_table :messages do |t|
      t.references :sender, polymorphic: true
      t.references :recipient, polymorphic: true
      t.string :subject
      t.text :content
      t.integer :read_status, default: 0
      t.integer :starring, default: 0
      t.integer :trashing, default: 0
      t.string :files, array: true, default: []

      t.timestamps
    end

    add_index :messages, :read_status
    add_index :messages, :starring
    add_index :messages, :trashing
  end
end
