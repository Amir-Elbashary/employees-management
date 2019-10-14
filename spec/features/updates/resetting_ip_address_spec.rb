require 'rails_helper'

RSpec.feature 'Resetting authorized IP by developer' do
  before do
    initialize_app_settings
    @update = create(:update)
  end

  scenario 'should reset IP address if employee is developer' do
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    visit admin_updates_path

    expect(page).to have_content(@update.version)
    expect(page).to have_link('Reset IP Address')
  end

  scenario 'should not reset IP address if employee is not developer' do
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    visit admin_updates_path

    expect(page).not_to have_link('Reset IP Address')
    expect(page).to have_content('You are not authorized to access this page')
  end
end
