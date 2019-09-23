class CreateRecruitments < ActiveRecord::Migration[5.2]
  def change
    create_table :recruitments do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.string :mobile_number
      t.string :landline_number
      t.string :position
      t.text :feedback
      t.integer :decision, default: 0
      t.string :cv

      t.timestamps
    end
  end
end
