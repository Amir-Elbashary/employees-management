class AddAttributesToAdmins < ActiveRecord::Migration[5.2]
  def change
    add_column :admins, :first_name, :string
    add_column :admins, :last_name, :string
    add_column :admins, :gender, :integer, default: 0
    add_column :admins, :birthdate, :date
    add_column :admins, :address, :string
    add_column :admins, :social_id, :string
    add_column :admins, :personal_email, :string
    add_column :admins, :business_email, :string
    add_column :admins, :mobile_numbers, :string
    add_column :admins, :landline_numbers, :string
    add_column :admins, :qualification, :string
    add_column :admins, :graduation_year, :integer
    add_column :admins, :date_of_employment, :date
    add_column :admins, :job_description, :string
    add_column :admins, :work_type, :integer, default: 0
    add_column :admins, :date_of_social_insurance_joining, :date
    add_column :admins, :social_insurance_number, :string
    add_column :admins, :military_status, :integer, default: 0
    add_column :admins, :marital_status, :integer, default: 0
    add_column :admins, :nationality, :string
    add_column :admins, :vacation_balance, :integer
    add_column :admins, :avatar, :string
  end
end
