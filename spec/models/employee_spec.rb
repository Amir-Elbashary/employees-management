require 'rails_helper'

RSpec.describe Employee, type: :model do
  describe 'Require validations' do
    it 'should has an email' do
      should validate_presence_of(:email)
    end

    it 'should has a password' do
      should validate_presence_of(:password)
    end

    it 'should has a first name' do
      should validate_presence_of(:first_name)
    end

    it 'should has a last name' do
      should validate_presence_of(:last_name)
    end
  end

  describe 'Has Associations' do
    it 'should belongs to section' do
      should belong_to(:section).optional
    end
  end
end
