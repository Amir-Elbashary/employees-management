require 'rails_helper'
include AdminHelpers

RSpec.feature 'Creating update' do
  before do
    initialize_app_settings
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    visit new_admin_update_path
  end

  context 'with valid data' do
    it 'should be announced if announce is selected' do
      fill_in 'Version', with: 1.01
      fill_in 'Changelog', with: 'The most awated day'
      check('Announce on timeline')
      click_button 'Submit'
      
      expect(page).to have_content('Update has been announced.')
      expect(Update.count).to eq(1)
      expect(page).to have_content(Update.first.version)

      visit admin_path
      expect(page).to have_content(Update.first.changelog)
    end

    it 'should not be announced if announce is not selected' do
      fill_in 'Version', with: 1.01
      fill_in 'Changelog', with: 'The most awated day'
      click_button 'Submit'
      
      expect(page).to have_content('Update has been announced.')
      expect(Update.count).to eq(1)
      expect(page).to have_content(Update.first.version)

      visit admin_path
      expect(page).not_to have_content(Update.first.version)
    end
  end

  scenario 'with duplicated data' do
    @update = create(:update, version: 2.4)

    fill_in 'Version', with: 2.4
    fill_in 'Changelog', with: 'The most awated day'
    click_button 'Submit'
 
    expect(page).to have_content('Version has already been taken')
    expect(Update.count).to eq(1)
  end
end
