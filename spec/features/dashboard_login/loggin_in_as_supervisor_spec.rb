require 'rails_helper'

RSpec.feature 'Loggin in as supervisor' do
  before do
    # @supervisor = create(:supervisor)
    # visit '/supervisors/sign_in'

    # expect(page).to have_button('Log in')
  end

  xscenario 'with valid credential' do
    fill_in 'Email', with: @supervisor.email
    fill_in 'Password', with: @supervisor.password
    click_button 'Log in'

    expect(page).to have_content(@supervisor.full_name)
  end

  xscenario 'with invalid credential' do
    fill_in 'Email', with: 'supervisor@test.com'
    fill_in 'Password', with: 'AdminAdmin'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
