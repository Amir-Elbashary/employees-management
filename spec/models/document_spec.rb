require 'rails_helper'

RSpec.describe Document, type: :model do
  describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name)
    end

    it 'should has a file' do
      should validate_presence_of(:file)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to section' do
      should belong_to(:employee)
    end
  end
end
