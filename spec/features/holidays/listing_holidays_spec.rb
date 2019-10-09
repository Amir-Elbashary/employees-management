require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing holidays' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Holiday)
    @holiday1 = create(:holiday)
    @holiday2 = create(:holiday)
    visit admin_holidays_path
  end

  scenario 'should has list of holidays' do
    expect(page).to have_content(@holiday1.name)
    expect(page).to have_content(@holiday2.name)
  end
end
