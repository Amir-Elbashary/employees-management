require 'rails_helper'

RSpec.describe React, type: :model do
  describe 'Require validations' do
  end

  describe 'Has Associations' do
    it 'belongs to timeline' do
      should belong_to(:timeline)
    end

    it 'belongs to reactor' do
      should belong_to(:reactor)
    end
  end
end
