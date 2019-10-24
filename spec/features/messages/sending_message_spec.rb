require 'rails_helper'
include AdminHelpers

RSpec.feature 'Sending messages' do
  before do
    @admin = create(:admin)
    @hr = create(:hr)
    @employee = create(:employee)
    @employee2 = create(:employee)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Message)
    assign_permission(@hr, :create, Message)
    visit new_admin_message_path
  end

  context 'with valid data' do
    it 'should be sent to all if "all" is sent' do
      fill_in 'message[recipient]', with: "all"
      fill_in 'message[subject]', with: 'Welcome email'
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(3)
      expect(@employee.received_messages.count).to eq(1)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(3)
      expect(@admin.received_messages.count).to eq(1)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(1)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).not_to have_content('All emails entered are invalid')
    end

    it 'should be sent to single emails if one mail is given' do
      fill_in 'message[recipient]', with: "#{@employee.email} "
      fill_in 'message[subject]', with: 'Welcome email'
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(1)
      expect(@employee.received_messages.count).to eq(1)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(1)
      expect(@admin.received_messages.count).to eq(0)
      expect(@admin.sent_messages.count).to eq(0)
      expect(page).to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).not_to have_content('All emails entered are invalid')
    end

    it 'should be sent to multiple emails if more than one is presented' do
      fill_in 'message[recipient]', with: "#{@employee.email} , #{@admin.email}"
      fill_in 'message[subject]', with: 'Welcome email'
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(2)
      expect(@employee.received_messages.count).to eq(1)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(2)
      expect(@admin.received_messages.count).to eq(1)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(0)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).not_to have_content('All emails entered are invalid')
    end

    it 'should bypass invalid email formats' do
      fill_in 'message[recipient]', with: "invalid_email@mail , #{@admin.email}"
      fill_in 'message[subject]', with: 'Welcome email'
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(1)
      expect(@employee.received_messages.count).to eq(0)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(1)
      expect(@admin.received_messages.count).to eq(1)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(0)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).not_to have_content('All emails entered are invalid')
    end
  end

  context 'with invalid data' do
    it 'should return error if all email are invalid' do
      fill_in 'message[recipient]', with: "inva"
      fill_in 'message[subject]', with: 'Welcome email'
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(0)
      expect(@employee.received_messages.count).to eq(0)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(0)
      expect(@admin.received_messages.count).to eq(0)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(0)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).not_to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).to have_content('Nothing sent, All emails entered are invalid')
    end

    it 'should not send without subject' do
      fill_in 'message[recipient]', with: "#{@admin.email}"
      fill_in 'message[subject]', with: ''
      fill_in 'message[content]', with: 'This is awesome mail'
      find('.mail-submit-link').click

      expect(Message.count).to eq(0)
      expect(@employee.received_messages.count).to eq(0)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(0)
      expect(@admin.received_messages.count).to eq(0)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(0)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).not_to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).to have_content('Nothing sent, All emails entered are invalid')
    end

    it 'should not send without content' do
      fill_in 'message[recipient]', with: "#{@admin.email}"
      fill_in 'message[subject]', with: 'Welcome mail'
      fill_in 'message[content]', with: ''
      find('.mail-submit-link').click

      expect(Message.count).to eq(0)
      expect(@employee.received_messages.count).to eq(0)
      expect(@employee.sent_messages.count).to eq(0)
      expect(@hr.received_messages.count).to eq(0)
      expect(@hr.sent_messages.count).to eq(0)
      expect(@admin.received_messages.count).to eq(0)
      expect(@admin.sent_messages.count).to eq(0)
      expect(@employee2.received_messages.count).to eq(0)
      expect(@employee2.sent_messages.count).to eq(0)
      expect(page).not_to have_content('Messages sent, Please check your sent messages to make sure they are sent')
      expect(page).to have_content('Nothing sent, All emails entered are invalid')
    end
  end
end
