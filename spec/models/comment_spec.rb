require 'rails_helper'

RSpec.describe Comment, type: :model do
  describe 'Require validations' do
    it 'should has a content' do
      should validate_presence_of(:content)
    end
  end

  describe 'Has Associations' do
    it 'belongs to timeline' do
      should belong_to(:timeline)
    end

    it 'belongs to commenter' do
      should belong_to(:commenter)
    end
  end
end
