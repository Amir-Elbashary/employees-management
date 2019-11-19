require 'rails_helper'

RSpec.describe PerformanceTopic, type: :model do
  describe 'Require validations' do
    it 'should has a title' do
      should validate_presence_of(:title)
    end

    it 'should has a unique title' do
      should validate_uniqueness_of(:title).case_insensitive
    end
  end
end
