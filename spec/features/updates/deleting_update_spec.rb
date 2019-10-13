require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting update' do
  before do
    initialize_app_settings
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    @update = create(:update)
    visit admin_updates_path
  end

  scenario 'should has list of updates' do
    expect(page).to have_content(@update.version)

    find('.delete-link').click
    expect(page).to have_content('Update has been delayed.')
    expect(page).not_to have_content(@update.changelog)
    expect(Update.count).to eq(0)
  end
end
