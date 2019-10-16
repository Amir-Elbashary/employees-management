require 'rails_helper'

RSpec.feature 'Marking notification as read/unread' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @notification = create(:notification, recipient: @employee)

    visit admin_path
    click_on(class: 'notification-menu-btn') 
    click_on(class: 'all-notifications-link')
  end

  scenario 'mark as read' do
    expect(page).to have_content(@notification.content)
    expect(Notification.unread.count).to eq(1)
    click_link('Mark as read')
    expect(Notification.unread.count).to eq(0)
  end

  scenario 'mark as unread' do
    @notification.read!
    expect(page).to have_content(@notification.content)
    expect(Notification.unread.count).to eq(0)
    click_link('Mark as unread')
    expect(Notification.unread.count).to eq(1)
  end

  scenario 'mark all as read' do
    @notification = create(:notification, recipient: @employee)

    expect(Notification.unread.count).to eq(2)
    click_on(class: 'mark-all-link')
    expect(Notification.unread.count).to eq(0)
  end
end
