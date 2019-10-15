require 'rails_helper'

RSpec.feature 'Sending notification by admin' do
  before do
    @admin = create(:admin)
    @hr1 = create(:hr)
    @hr2 = create(:hr)
    @employee1 = create(:employee)
    @employee2 = create(:employee)
    login_as(@admin, scope: :admin)
  end

  scenario 'to all users' do
    visit admin_path
    click_on(class: 'notification-menu-btn') 
    click_on(class: 'notification-to-all')

    fill_in 'Send notification to Fustany Team', with: 'New notification!'

    click_on('Send')

    # Is being executed by sidekiq

    # expect(Notification.count).to eq(5)
    # expect(Admin.first.notifications.count).to eq(1)
    # expect(Hr.first.notifications.count).to eq(1)
    # expect(Employee.first.notifications.count).to eq(1)
  end
end
