require 'rails_helper'

RSpec.describe Timeline, type: :model do
  describe 'Require validations' do
    it 'should has a content' do
      should validate_presence_of(:content)
    end
  end

  describe 'Has Associations' do
    it 'belongs to admin' do
      should belong_to(:admin).optional
    end

    it 'belongs to hr' do
      should belong_to(:hr).optional
    end

    it 'belongs to employee' do
      should belong_to(:employee).optional
    end
  end
end
