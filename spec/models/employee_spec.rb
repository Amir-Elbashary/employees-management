require 'rails_helper'

RSpec.describe Employee, type: :model do
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
    it 'should have many employees' do
      should have_many(:employees)
    end
    
    it 'should have many documents' do
      should have_many(:documents)
    end

    it 'should have many room messages' do
      should have_many(:room_messages)
    end

    it 'should belong to supervisor' do
      should belong_to(:supervisor).optional
    end

    it 'should belong to section' do
      should belong_to(:section).optional
    end
  end
end
