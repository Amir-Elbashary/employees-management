require 'rails_helper'

RSpec.feature 'Refreshing permissions' do
  before do
    @settings = create(:setting)
  end

  context 'while logged in as H.R' do
    it 'should return not authorized' do
      @hr = create(:hr)
      login_as(@hr, scope: :hr)
      visit dashboard_admin_settings_path

      expect(page).to have_content('You are not authorized to access this page.')
    end
  end

  context 'while logged in as admin' do
    it 'should ensure all permissions are added' do
      @admin = create(:admin)
      login_as(@admin, scope: :admin)
      visit dashboard_admin_settings_path

      expect(page).to have_button('Refresh Permissions')
      find('.refresh-link').click
      expect(page).to have_content("Permissions refreshed successfully, #{Permission.count} permissions added")
    end
  end
end
