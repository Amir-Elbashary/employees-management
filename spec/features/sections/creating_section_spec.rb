require 'rails_helper'

RSpec.feature 'Creating section' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    visit new_admin_section_path
  end

  scenario 'with valid data' do
    fill_in 'Name', with: 'Software Development'
    click_link 'Add more sub sections'
    fill_in 'Sub Section Name', with: '1'

    click_button 'Submit'
    
    expect(page).to have_content('Section has been saved.')
    expect(page).to have_content('Software Development')
    expect(Section.count).to eq(2)
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''

    click_button 'Submit'
    
    expect(page).to have_content('Name can\'t be blank')
    expect(Section.count).to eq(0)
  end
end
