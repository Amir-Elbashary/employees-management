require 'rails_helper'

RSpec.feature 'Deleting section' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @section = create(:section)
    visit admin_sections_path
  end

  scenario 'should has list of sections' do
    expect(page).to have_content(@section.name)
    expect(Section.count).to eq(1)

    find('.delete-link').click
    expect(Section.count).to eq(0)
    expect(page).to have_content('Section was removed.')
    expect(page).not_to have_content(@section.name)
  end
end
