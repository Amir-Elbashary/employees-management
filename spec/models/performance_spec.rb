require 'rails_helper'

RSpec.describe Performance, type: :model do
  describe 'Require validations' do
    it 'should has a year' do
      should validate_presence_of(:year)
    end

    it 'should has a month' do
      should validate_presence_of(:month)
    end

    it 'should has a topic' do
      should validate_presence_of(:topic)
    end

    it 'should has a unique topic' do
      should validate_uniqueness_of(:topic).case_insensitive.scoped_to(:employee_id, :year, :month)
    end

    it 'should has a score' do
      should validate_presence_of(:score)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to employee' do
      should belong_to(:employee)
    end
  end
end
