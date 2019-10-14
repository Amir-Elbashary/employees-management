require 'rails_helper'

RSpec.feature 'Listing updates' do
  before do
    initialize_app_settings
    @update1 = create(:update)
    @update2 = create(:update)
  end

  scenario 'should has list of updates if employee is developer' do
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    visit admin_updates_path

    expect(page).to have_content(@update1.version)
    expect(page).to have_content(@update2.version)
  end

  scenario 'should return unauthorized of employee is not developer' do
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    visit admin_updates_path

    expect(page).to have_content('You are not authorized to access this page')
  end
end
