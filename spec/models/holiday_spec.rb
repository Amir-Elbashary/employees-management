require 'rails_helper'

RSpec.describe Holiday, type: :model do
  describe 'Require validations' do
    it 'should has a name' do
      should validate_presence_of(:name)
    end

    it 'should has a content' do
      should validate_presence_of(:content)
    end

    it 'should has a month' do
      should validate_presence_of(:month)
    end

    it 'should has a year' do
      should validate_presence_of(:year)
    end

    it 'should has a duration' do
      should validate_presence_of(:duration)
    end

    it 'should has a start date' do
      should validate_presence_of(:starts_on)
    end
  end
end
