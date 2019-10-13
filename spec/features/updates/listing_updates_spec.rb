require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing updates' do
  before do
    initialize_app_settings
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    @update1 = create(:update)
    @update2 = create(:update)
    visit admin_updates_path
  end

  scenario 'should has list of updates' do
    expect(page).to have_content(@update1.version)
    expect(page).to have_content(@update2.version)
  end
end
