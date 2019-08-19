class AddAttributesToEmployees < ActiveRecord::Migration[5.2]
  def change
    add_column :employees, :first_name, :string
    add_column :employees, :last_name, :string
    add_column :employees, :gender, :integer, default: 0
    add_column :employees, :birthdate, :date
    add_column :employees, :address, :string
    add_column :employees, :social_id, :string
    add_column :employees, :personal_email, :string
    add_column :employees, :business_email, :string
    add_column :employees, :mobile_numbers, :string
    add_column :employees, :landline_numbers, :string
    add_column :employees, :qualification, :string
    add_column :employees, :graduation_year, :integer
    add_column :employees, :date_of_employment, :date
    add_column :employees, :job_description, :string
    add_column :employees, :work_type, :integer, default: 0
    add_column :employees, :date_of_social_insurance_joining, :date
    add_column :employees, :social_insurance_number, :string
    add_column :employees, :military_status, :integer, default: 0
    add_column :employees, :marital_status, :integer, default: 0
    add_column :employees, :nationality, :string
    add_column :employees, :vacation_balance, :integer
    add_column :employees, :avatar, :string
  end
end
