require 'rails_helper'

RSpec.feature 'Loggin in as admin' do
  before do
    @admin = create(:admin)
    visit '/admins/sign_in'

    expect(page).to have_button('Log in')
  end

  scenario 'with valid credential' do
    fill_in 'admin[email]', with: @admin.email
    fill_in 'admin[password]', with: @admin.password
    click_button 'Log in'

    expect(page).to have_content(@admin.full_name)
  end

  scenario 'with invalid credential' do
    fill_in 'admin[email]', with: 'admin@test.com'
    fill_in 'admin[password]', with: 'AdminAdmin'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
