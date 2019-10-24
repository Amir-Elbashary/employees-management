require 'rails_helper'
include AdminHelpers

RSpec.feature 'Visiting inbox messages' do
  before do
    initialize_app_settings
    @hr = create(:hr)
    assign_permission(@hr, :read, Message)
    @employee = create(:employee)
    @message = create(:message, sender: @hr, recipient: @employee)
  end

  scenario 'show show all unread messages' do
    login_as(@employee, scope: :employee)
    visit admin_messages_path

    expect(@employee.sent_messages.count).to eq(0)
    expect(@employee.received_messages.count).to eq(1)
    expect(@employee.received_messages.unread.count).to eq(1)
    expect(page).to have_content(@message.subject)
  end

  scenario 'reading sent message by sender should not mark it as read' do
    login_as(@hr, scope: :hr)
    visit admin_messages_path

    expect(@hr.sent_messages.count).to eq(1)
    expect(@hr.received_messages.count).to eq(0)
    expect(@hr.sent_messages.unread.count).to eq(1)
    expect(page).not_to have_content(@message.subject)
    expect(page).to have_content('Your mailbox is empty')

    find('.sent-link').click
    expect(page).to have_content(@message.subject)

    find('.unread-message-link').click
    expect(@hr.sent_messages.unread.count).to eq(1)
    expect(@employee.received_messages.unread.count).to eq(1)
  end

  scenario 'reading sent message by recipient should mark it as read' do
    login_as(@employee, scope: :employee)
    visit admin_messages_path

    expect(@employee.sent_messages.count).to eq(0)
    expect(@employee.received_messages.count).to eq(1)
    expect(@employee.received_messages.unread.count).to eq(1)

    find('.sent-link').click
    expect(page).to have_content('Your mailbox is empty')

    find('.inbox-link').click
    expect(page).to have_content(@message.subject)

    find('.unread-message-link').click
    expect(@employee.received_messages.unread.count).to eq(0)
    expect(@hr.sent_messages.unread.count).to eq(0)
  end

  scenario 'clicking mark all as read should mark all received messages as read' do
    login_as(@employee, scope: :employee)
    visit admin_messages_path

    expect(@employee.sent_messages.count).to eq(0)
    expect(@employee.received_messages.count).to eq(1)
    expect(@employee.received_messages.unread.count).to eq(1)
    expect(page).to have_content(@message.subject)

    find('.mark-all-as-read-link').click
    expect(@employee.received_messages.unread.count).to eq(0)
    expect(@hr.sent_messages.unread.count).to eq(0)
  end
end
