require 'rails_helper'
include AdminHelpers

RSpec.feature 'Editing recruitment' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Recruitment)
    assign_permission(@hr, :update, Recruitment)
    @recruitment = create(:recruitment)
    visit edit_admin_recruitment_path(@recruitment)
  end

  scenario 'with valid data' do
    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Rec'
    fill_in 'Email', with: 'rec@test.com'
    fill_in 'Mobile Number', with: '011'
    
    click_button 'Submit'
    
    expect(page).to have_content('Recruitment has been successfully updated.')
  end

  scenario 'with invalid data' do
    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Mobile Number', with: ''

    click_button 'Submit'
    
    expect(page).to have_content('First name can\'t be blank')
    expect(page).to have_content('Last name can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Mobile number can\'t be blank')
  end

  scenario 'with duplicated data' do
    @recruitment = create(:recruitment)

    fill_in 'First Name', with: @recruitment.first_name
    fill_in 'Last Name', with: @recruitment.last_name
    fill_in 'Email', with: @recruitment.email
    fill_in 'Mobile Number', with: @recruitment.mobile_number

    click_button 'Submit'
    
    expect(page).to have_content('Email has already been taken')
  end
end
