require 'rails_helper'

RSpec.describe Message, type: :model do
  describe 'Require validations' do
    it 'should has a content' do
      should validate_presence_of(:content)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to sender' do
      should belong_to(:sender)
    end

    it 'should belongs to recipient' do
      should belong_to(:recipient)
    end
  end
end
