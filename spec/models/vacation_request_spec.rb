require 'rails_helper'

RSpec.describe VacationRequest, type: :model do
  describe 'Require validations' do
    it 'should has a start date' do
      should validate_presence_of(:starts_on)
    end

    it 'should has an end date' do
      should validate_presence_of(:ends_on)
    end

    it 'should has a reason' do
      should validate_presence_of(:reason)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to requester' do
      should belong_to(:requester)
    end
  end
end
