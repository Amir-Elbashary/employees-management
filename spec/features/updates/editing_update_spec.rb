require 'rails_helper'

RSpec.feature 'Editing update info' do
  before do
    initialize_app_settings
    @employee = create(:employee, email: 'amir.adel@fustany.com')
    login_as(@employee, scope: :employee)
    @update = create(:update)
    visit edit_admin_update_path(@update)
  end

  context 'with valid data' do
    it 'should modify update info' do
      fill_in 'Version', with: 8.8
      fill_in 'Changelog', with: 'New Changelog'

      click_button 'Submit'
      
      expect(page).to have_content('Changes has been saved')
      expect(Update.first.changelog).to eq('New Changelog')
    end
  end


  context 'with invalid data' do
    it 'should not update info' do
      fill_in 'Version', with: ''

      click_button 'Submit'

      expect(page).to have_content('Version can\'t be blank')
    end
  end

  context 'with duplicated version' do
    it 'should not update info' do
      @update = create(:update)

      fill_in 'Version', with: @update.version

      click_button 'Submit'
      
      expect(page).to have_content('Version has already been taken')
    end
  end
end
