class AddAttributesToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :gender, :integer, default: 0
    add_column :users, :birthdate, :date
    add_column :users, :address, :string
    add_column :users, :social_id, :string
    add_column :users, :personal_email, :string
    add_column :users, :business_email, :string
    add_column :users, :mobile_numbers, :string
    add_column :users, :landline_numbers, :string
    add_column :users, :qualification, :string
    add_column :users, :graduation_year, :integer
    add_column :users, :date_of_employment, :date
    add_column :users, :job_description, :string
    add_column :users, :work_type, :integer, default: 0
    add_column :users, :date_of_social_insurance_joining, :date
    add_column :users, :social_insurance_number, :string
    add_column :users, :military_status, :integer, default: 0
    add_column :users, :marital_status, :integer, default: 0
    add_column :users, :nationality, :string
    add_column :users, :vacation_balance, :integer
    add_column :users, :avatar, :string
  end
end
