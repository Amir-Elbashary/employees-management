require 'rails_helper'
include AdminHelpers

RSpec.feature 'Showing recruitment' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @recruitment1 = create(:recruitment)
    @recruitment2 = create(:recruitment)

    assign_permission(@hr, :read, Recruitment)
    visit admin_recruitments_path
  end

  scenario 'should has list of recruitments' do
    expect(page).to have_content(@recruitment1.full_name)
    expect(page).to have_content(@recruitment2.full_name)

    click_link(@recruitment1.full_name)

    expect(page).to have_content(@recruitment1.email)
  end
end
