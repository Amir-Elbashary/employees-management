require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing performance topics' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, PerformanceTopic)
    login_as(@hr, scope: :hr)
    @performance_topic1 = create(:performance_topic)
    @performance_topic2 = create(:performance_topic)
    visit admin_performance_topics_path
  end

  scenario 'should has list of performance topics' do
    expect(page).to have_content(@performance_topic1.title)
    expect(page).to have_content(@performance_topic2.title)
  end
end
