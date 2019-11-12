require 'rails_helper'

RSpec.describe Attendance, type: :model do
  describe 'Require validations' do
    it 'should has a checkin' do
      should validate_presence_of(:checkin)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to attender' do
      should belong_to(:attender)
    end

    it 'should belongs to admin' do
      # should belong_to(:admin).optional
      # To be
      should_not belong_to(:admin).optional
    end

    it 'should belongs to H.R' do
      # should belong_to(:hr).optional
      # To be
      should_not belong_to(:hr).optional
    end

    it 'should belongs to employee' do
      # should belong_to(:employee).optional
      # To be
      should_not belong_to(:employee).optional
    end
  end
end
