require 'rails_helper'

RSpec.feature 'Loggin in as supervisor' do
  before do
    @hr = create(:hr)
    visit '/hrs/sign_in'

    expect(page).to have_button('Log in')
  end

  scenario 'with valid credential' do
    fill_in 'Email', with: @hr.email
    fill_in 'Password', with: @hr.password
    click_button 'Log in'

    expect(page).to have_content(@hr.full_name)
  end

  scenario 'with invalid credential' do
    fill_in 'Email', with: 'hr@test.com'
    fill_in 'Password', with: 'AdminAdmin'
    click_button 'Log in'

    expect(page).to have_content('Invalid Email or password.')
  end
end
