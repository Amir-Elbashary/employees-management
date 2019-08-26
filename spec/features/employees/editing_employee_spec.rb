require 'rails_helper'
include AdminHelpers

RSpec.feature 'Editing employee' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :update, Employee)
    visit edit_admin_employee_path(@employee)
  end

  scenario 'with valid data' do
    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Name'
    attach_file('Avatar', File.absolute_path('./spec/support/test_image.jpg'))
    
    click_button 'Submit'
    
    expect(page).to have_content('Employee has been successfully updated.')
  end

  scenario 'with invalid data' do
    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    click_button 'Submit'
    
    expect(page).to have_content('First name can\'t be blank')
    expect(page).to have_content('Last name can\'t be blank')
  end
end
