require 'rails_helper'

RSpec.feature 'Listing sections' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @section1 = create(:section)
    @section2 = create(:section)
    visit admin_sections_path
  end

  scenario 'should has list of sections' do
    expect(page).to have_content(@section1.name)
    expect(page).to have_content(@section2.name)
  end
end
