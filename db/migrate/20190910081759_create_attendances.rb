class CreateAttendances < ActiveRecord::Migration[5.2]
  def change
    create_table :attendances do |t|
      t.references :employee, foreign_key: true
      t.datetime :checkin
      t.datetime :checkout
      t.float :time_spent, default: 0

      t.timestamps
    end
  end
end
