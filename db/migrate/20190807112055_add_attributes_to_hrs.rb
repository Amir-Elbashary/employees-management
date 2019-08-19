class AddAttributesToHrs < ActiveRecord::Migration[5.2]
  def change
    add_column :hrs, :first_name, :string
    add_column :hrs, :last_name, :string
    add_column :hrs, :gender, :integer, default: 0
    add_column :hrs, :birthdate, :date
    add_column :hrs, :address, :string
    add_column :hrs, :social_id, :string
    add_column :hrs, :personal_email, :string
    add_column :hrs, :business_email, :string
    add_column :hrs, :mobile_numbers, :string
    add_column :hrs, :landline_numbers, :string
    add_column :hrs, :qualification, :string
    add_column :hrs, :graduation_year, :integer
    add_column :hrs, :date_of_employment, :date
    add_column :hrs, :job_description, :string
    add_column :hrs, :work_type, :integer, default: 0
    add_column :hrs, :date_of_social_insurance_joining, :date
    add_column :hrs, :social_insurance_number, :string
    add_column :hrs, :military_status, :integer, default: 0
    add_column :hrs, :marital_status, :integer, default: 0
    add_column :hrs, :nationality, :string
    add_column :hrs, :vacation_balance, :integer
    add_column :hrs, :avatar, :string
  end
end
