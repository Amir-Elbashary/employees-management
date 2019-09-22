require 'rails_helper'

RSpec.describe Recruitment, type: :model do
  describe 'Require validations' do
    it 'should has a first name' do
      should validate_presence_of(:first_name)
    end

    it 'should has a last name' do
      should validate_presence_of(:last_name)
    end

    it 'should has unique email' do
      should validate_presence_of(:email)
      should validate_uniqueness_of(:email).case_insensitive
    end
  end

  describe 'Has Associations' do
  end
end
