require 'rails_helper'
include AdminHelpers

RSpec.feature 'Updating admin profile' do
  scenario 'with valid data as an admin' do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)

    visit admin_path
    click_on(class: 'profile-pic') 
    click_on(class: 'my-profile-btn')

    expect(page).to have_content('Edit profile')

    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Admin'
    fill_in 'Nationality', with: 'Egyptian'
    select('Engaged', from: 'Marital Status').select_option
    select('Completed', from: 'Military Status').select_option
    select('Male', from: 'Gender').select_option
    fill_in 'Birthdate', with: '19/9/1990'
    fill_in 'Mobile Numbers', with: '011, 012'
    fill_in 'Landline Numbers', with: '022, 023'
    fill_in 'Address', with: 'New Address'
    fill_in 'Social ID', with: '1234567890'
    fill_in 'Personal Email', with: 'new.email@test.com'
    fill_in 'Business Email', with: 'new.b.email@test.com'
    fill_in 'Qualification', with: 'Bachelor'
    fill_in 'Graduation Year', with: '2013'
    fill_in 'Date of Employment', with: '20/02/2019'
    fill_in 'Job Description', with: 'Ruby on Rails Developer'
    select('Full time', from: 'Work Type').select_option
    fill_in 'Vacation Balance', with: '21'
    fill_in 'Social Insurance joining date', with: '1/1/2020'
    fill_in 'Social Insurance Number', with: '9876543210'
    fill_in 'Password', with: 'new_admin'
    fill_in 'Password Confirmation', with: 'new_admin'

    click_button 'Submit'

    expect(Admin.first.full_name).to eq('New Admin')
    expect(Admin.first.nationality).to eq('Egyptian')
    expect(Admin.first.marital_status).to eq('engaged')
    expect(Admin.first.military_status).to eq('completed')
    expect(Admin.first.gender).to eq('male')
    expect(formatted_date(Admin.first.birthdate)).to eq('19/09/1990')
    expect(Admin.first.mobile_numbers).to eq('011, 012')
    expect(Admin.first.landline_numbers).to eq('022, 023')
    expect(Admin.first.address).to eq('New Address')
    expect(Admin.first.social_id).to eq('1234567890')
    expect(Admin.first.personal_email).to eq('new.email@test.com')
    expect(Admin.first.business_email).to eq('new.b.email@test.com')
    expect(Admin.first.qualification).to eq('Bachelor')
    expect(Admin.first.graduation_year).to eq(2013)
    expect(formatted_date(Admin.first.date_of_employment)).to eq('20/02/2019')
    expect(Admin.first.job_description).to eq('Ruby on Rails Developer')
    expect(Admin.first.work_type).to eq('full_time')
    expect(Admin.first.vacation_balance).to eq(21)
    expect(formatted_date(Admin.first.date_of_social_insurance_joining)).to eq('01/01/2020')
    expect(Admin.first.social_insurance_number).to eq('9876543210')
    expect(Admin.first.valid_password?('new_admin')).to eq(true)
  end

  scenario 'with valid data as H.R' do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)

    visit admin_path
    click_on(class: 'profile-pic') 
    click_on(class: 'my-profile-btn')

    expect(page).to have_content('Edit profile')

    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Admin'
    fill_in 'Nationality', with: 'Egyptian'
    select('Engaged', from: 'Marital Status').select_option
    select('Completed', from: 'Military Status').select_option
    select('Male', from: 'Gender').select_option
    fill_in 'Birthdate', with: '19/9/1990'
    fill_in 'Mobile Numbers', with: '011, 012'
    fill_in 'Landline Numbers', with: '022, 023'
    fill_in 'Address', with: 'New Address'
    fill_in 'Social ID', with: '1234567890'
    fill_in 'Personal Email', with: 'new.email@test.com'
    fill_in 'Business Email', with: 'new.b.email@test.com'
    fill_in 'Qualification', with: 'Bachelor'
    fill_in 'Graduation Year', with: '2013'
    fill_in 'Date of Employment', with: '20/02/2019'
    fill_in 'Job Description', with: 'Ruby on Rails Developer'
    select('Full time', from: 'Work Type').select_option
    fill_in 'Vacation Balance', with: '21'
    fill_in 'Social Insurance joining date', with: '1/1/2020'
    fill_in 'Social Insurance Number', with: '9876543210'
    fill_in 'Password', with: 'new_admin'
    fill_in 'Password Confirmation', with: 'new_admin'

    click_button 'Submit'

    expect(Hr.first.full_name).to eq('New Admin')
    expect(Hr.first.nationality).to eq('Egyptian')
    expect(Hr.first.marital_status).to eq('engaged')
    expect(Hr.first.military_status).to eq('completed')
    expect(Hr.first.gender).to eq('male')
    expect(formatted_date(Hr.first.birthdate)).to eq('19/09/1990')
    expect(Hr.first.mobile_numbers).to eq('011, 012')
    expect(Hr.first.landline_numbers).to eq('022, 023')
    expect(Hr.first.address).to eq('New Address')
    expect(Hr.first.social_id).to eq('1234567890')
    expect(Hr.first.personal_email).to eq('new.email@test.com')
    expect(Hr.first.business_email).to eq('new.b.email@test.com')
    expect(Hr.first.qualification).to eq('Bachelor')
    expect(Hr.first.graduation_year).to eq(2013)
    expect(formatted_date(Hr.first.date_of_employment)).to eq('20/02/2019')
    expect(Hr.first.job_description).to eq('Ruby on Rails Developer')
    expect(Hr.first.work_type).to eq('full_time')
    expect(Hr.first.vacation_balance).to eq(21)
    expect(formatted_date(Hr.first.date_of_social_insurance_joining)).to eq('01/01/2020')
    expect(Hr.first.social_insurance_number).to eq('9876543210')
    expect(Hr.first.valid_password?('new_admin')).to eq(true)
  end
end
