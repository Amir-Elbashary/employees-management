require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe 'Require validations' do
    it 'should has a content' do
      should validate_presence_of(:content)
    end
  end

  describe 'Has Associations' do
  end
end
