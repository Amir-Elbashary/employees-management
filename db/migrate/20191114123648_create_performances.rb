class CreatePerformances < ActiveRecord::Migration[5.2]
  def change
    create_table :performances do |t|
      t.references :employee
      t.integer :year
      t.integer :month
      t.string :topic
      t.float :score
      t.text :comment
      t.text :hr_comment

      t.timestamps
    end
  end
end
