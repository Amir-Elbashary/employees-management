require 'rails_helper'

RSpec.feature 'Deleting section' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @section = create(:section)
  end

  context 'while it has no employees assigned to it' do
    it 'should delete this section' do
      visit admin_sections_path

      expect(page).to have_content(@section.name)
      expect(Section.count).to eq(1)

      find('.delete-link').click
      expect(Section.count).to eq(0)
      expect(page).to have_content('Section was removed.')
      expect(page).not_to have_content(@section.name)
    end
  end

  context 'while it has employees assigned to it' do
    it 'should not delete this section' do
      @sub_section = create(:section, parent: @section)
      @employee = create(:employee, section: @sub_section)
      visit admin_sections_path

      expect(page).to have_content(@sub_section.name)
      expect(Section.count).to eq(2)

      find('.delete-link').click
      expect(Section.count).to eq(2)
      expect(page).to have_content(@employee.full_name)
      expect(page).to have_content("move them first, employees are (#{@employee.full_name})")
      expect(page).to have_content(@section.name)
    end
  end
end
