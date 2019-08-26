require 'rails_helper'

RSpec.feature 'Listing roles' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @role1 = create(:role)
    @role2 = create(:role)
    visit admin_roles_path
  end

  scenario 'should has list of roles' do
    expect(page).to have_content(@role1.name)
    expect(page).to have_content(@role2.name)
  end
end
