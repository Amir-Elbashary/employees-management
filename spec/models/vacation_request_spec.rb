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

    it 'should belong to employee' do
      should belong_to(:employee)
      # To be
      # should_not belong_to(:employee)
    end

    it 'should belong to supervisor' do
      should belong_to(:supervisor).optional
      # To be
      # should_not belong_to(:supervisor).optional
    end

    it 'should belong to H.R' do
      should belong_to(:hr).optional
      # To be
      # should_not belong_to(:hr).optional
    end
  end
end
