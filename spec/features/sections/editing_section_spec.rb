require 'rails_helper'

RSpec.feature 'Editing section' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @section = create(:section)
    visit edit_admin_section_path(@section)
  end

  scenario 'with valid data' do
    fill_in 'Name', with: 'Software Development'
    click_link 'Add more sub sections'

    click_button 'Submit'
    
    expect(page).to have_content('Section has been updated.')
    expect(page).to have_content('Software Development')
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''

    click_button 'Submit'
    
    expect(page).to have_content('Name can\'t be blank')
  end
end
