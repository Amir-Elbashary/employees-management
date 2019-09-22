require 'rails_helper'

RSpec.feature 'Editing subject' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @hr = create(:hr)
    visit edit_admin_hr_path(@hr)
  end

  scenario 'with valid data' do
    fill_in 'First Name', with: 'Super'
    fill_in 'Last Name', with: 'Visor'
    fill_in 'Email', with: 'supervisor@test.com'
    fill_in 'Password', with: 'supersuper'
    fill_in 'Password Confirmation', with: 'supersuper'
    attach_file('Avatar', File.absolute_path('./spec/support/test_image.jpg'))
    
    click_button 'Submit'
    
    expect(page).to have_content('H.R has been successfully updated.')
  end

  scenario 'with invalid data' do
    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    fill_in 'Email', with: ''
    click_button 'Submit'
    
    expect(page).to have_content('First name can\'t be blank')
    expect(page).to have_content('Last name can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
  end

  scenario 'with duplicated data' do
    @hr = create(:hr)

    fill_in 'First Name', with: @hr.first_name
    fill_in 'Last Name', with: @hr.last_name
    fill_in 'Email', with: @hr.email
    click_button 'Submit'
    
    expect(page).to have_content('Email has already been taken')
  end
end
