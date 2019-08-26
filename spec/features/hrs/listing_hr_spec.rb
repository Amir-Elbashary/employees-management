require 'rails_helper'

RSpec.feature 'Listing H.Rs' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @hr1 = create(:hr)
    @hr2 = create(:hr)
    visit admin_hrs_path
  end

  scenario 'should has list of H.Rs' do
    expect(page).to have_content(@hr1.full_name)
    expect(page).to have_content(@hr2.full_name)
  end
end
