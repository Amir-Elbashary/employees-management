require 'rails_helper'

RSpec.feature 'Creating H.R by admin' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    visit new_admin_hr_path
  end

  scenario 'with valid data' do
    fill_in 'First Name', with: 'Human'
    fill_in 'Last Name', with: 'Resources'
    fill_in 'Email', with: 'hr@test.com'
    fill_in 'Password', with: 'hrhrhrhr'
    fill_in 'Password Confirmation', with: 'hrhrhrhr'
    attach_file('Avatar', File.absolute_path('./spec/support/test_image.jpg'))
    click_button 'Submit'
    
    expect(page).to have_content("#{Hr.first.full_name} has joined Fustany Team.")
    expect(page).to have_content(Hr.first.full_name)
  end

  scenario 'with invalid data' do
    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_button 'Submit'
    
    expect(page).to have_content('First name can\'t be blank')
    expect(page).to have_content('Last name can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
    expect(Hr.count).to eq(0)
  end

  scenario 'with duplicated data' do
    @hr = create(:hr)

    fill_in 'First Name', with: @hr.first_name
    fill_in 'Last Name', with: @hr.last_name
    fill_in 'Email', with: @hr.email
    fill_in 'Password', with: @hr.password
    fill_in 'Password Confirmation', with: @hr.password
    click_button 'Submit'
    
    expect(page).to have_content('Email has already been taken')
    expect(Hr.count).to eq(1)
  end
end
