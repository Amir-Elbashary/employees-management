require 'rails_helper'

RSpec.describe RoomMessage, type: :model do
  describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:message)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to employee' do
      should belong_to(:employee)
    end

    it 'should belongs to room' do
      should belong_to(:room)
    end
  end
end
