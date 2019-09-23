require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting recruitment' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, Recruitment)
    assign_permission(@hr, :destroy, Recruitment)
    login_as(@hr, scope: :hr)
    @recruitment = create(:recruitment)
    visit admin_recruitments_path
  end

  scenario 'should has list of recruitments' do
    expect(page).to have_content(@recruitment.full_name)

    find('.delete-link').click
    expect(page).to have_content('Recruitment was deleted.')
    expect(page).not_to have_content(@recruitment.full_name)
  end
end
