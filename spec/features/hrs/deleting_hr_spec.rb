require 'rails_helper'

RSpec.feature 'Deleting H.R' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @hr = create(:hr)
    visit admin_hrs_path
  end

  scenario 'should has list of H.Rs' do
    expect(page).to have_content(@hr.full_name)

    find('.delete-link').click
    expect(page).to have_content('H.R was removed from Fustany Team.')
    expect(page).not_to have_content(@hr.full_name)
  end
end
