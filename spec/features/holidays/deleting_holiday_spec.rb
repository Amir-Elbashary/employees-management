require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting holiday' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Holiday)
    assign_permission(@hr, :destroy, Holiday)
    @holiday = create(:holiday)
    visit admin_holidays_path
  end

  scenario 'should has list of holidays' do
    expect(page).to have_content(@holiday.name)

    find('.delete-link').click
    expect(page).to have_content('Holiday was canceled.')
    expect(page).not_to have_content(@holiday.name)
  end
end
