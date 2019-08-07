require 'rails_helper'

RSpec.feature 'Updating admin profile' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
  end

  scenario 'with valid data' do
    visit admin_path
    click_on(class: 'profile-pic') 
    click_on(class: 'my-profile-btn')

    expect(page).to have_content('Edit profile')

    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Admin'

    click_button 'Submit'

    expect(Admin.first.full_name).to eq('New Admin')
  end
end
