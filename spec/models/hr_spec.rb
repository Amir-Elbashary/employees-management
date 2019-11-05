require 'rails_helper'

RSpec.describe Hr, type: :model do
  describe 'Require validations' do
    it 'should has an email' do
      should validate_presence_of(:email)
    end

    it 'should has a password' do
      should validate_presence_of(:password)
    end

    it 'should has a first name' do
      should validate_presence_of(:first_name)
    end

    it 'should has a last name' do
      should validate_presence_of(:last_name)
    end
  end

  describe 'Has Associations' do
    it 'should have many notifications' do
      should have_many(:notifications)
    end

    it 'should have many reacts' do
      should have_many(:reacts)
    end

    it 'should have many comments' do
      should have_many(:comments)
    end

    it 'should have many sent messages' do
      should have_many(:sent_messages)
    end

    it 'should have many received messages' do
      should have_many(:received_messages)
    end

    it 'should have many vacation requests' do
      should have_many(:vacation_requests)
    end

    it 'should have many attendances' do
      should have_many(:attendances)
    end
  end
end
