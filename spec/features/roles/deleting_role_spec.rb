require 'rails_helper'

RSpec.feature 'Deleting role' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @role = create(:role)
    visit admin_roles_path
  end

  scenario 'should has list of subjects' do
    expect(page).to have_content(@role.name)

    find('.delete-link').click
    expect(page).to have_content('Role was deleted.')
    expect(page).not_to have_content(@role.name)
  end
end
