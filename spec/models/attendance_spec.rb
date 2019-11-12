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
  end
end
