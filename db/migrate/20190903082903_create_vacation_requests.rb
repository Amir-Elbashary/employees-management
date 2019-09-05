class CreateVacationRequests < ActiveRecord::Migration[5.2]
  def change
    create_table :vacation_requests do |t|
      t.references :employee, foreign_key: true
      t.references :hr, foreign_key: true
      t.integer :supervisor_id
      t.date :starts_on
      t.date :ends_on
      t.text :reason
      t.text :supervisor_feedback
      t.text :hr_feedback
      t.integer :status, default: 0
      t.text :escalation_reason

      t.timestamps
    end

    add_index :vacation_requests, :supervisor_id
  end
end
