class CreateHolidays < ActiveRecord::Migration[5.2]
  def change
    create_table :holidays do |t|
      t.string :name
      t.text :content
      t.integer :month
      t.integer :year
      t.integer :duration
      t.date :starts_on
      t.date :ends_on

      t.timestamps
    end
  end
end
