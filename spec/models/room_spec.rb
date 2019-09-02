require 'rails_helper'

RSpec.describe Room, type: :model do
  describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name)
    end

    it 'should has a unique name' do
      should validate_uniqueness_of(:name).case_insensitive
    end
  end

  describe 'Has Associations' do
    it 'should has many room messages' do
      should have_many(:room_messages)
    end
  end
end
