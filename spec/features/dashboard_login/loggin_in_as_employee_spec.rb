require 'rails_helper'

RSpec.feature 'Loggin in as employee' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    visit '/employees/sign_in'

    expect(page).to have_button('Log in')
  end

  scenario 'with valid credential' do
    fill_in 'employee[email]', with: @employee.email
    fill_in 'employee[password]', with: @employee.password
    click_button 'Log in'

    expect(page).to have_content(@employee.full_name)
  end

  scenario 'with invalid credential' do
    fill_in 'employee[email]', with: 'hr@test.com'
    fill_in 'employee[password]', with: 'AdminAdmin'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
