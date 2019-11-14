require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting performance topic' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, PerformanceTopic)
    assign_permission(@hr, :destroy, PerformanceTopic)
    login_as(@hr, scope: :hr)
    @performance_topic = create(:performance_topic)
    visit admin_performance_topics_path
  end

  scenario 'should delete performance topics' do
    expect(page).to have_content(@performance_topic.title)
    expect(PerformanceTopic.count).to eq(1)

    find('.delete-link').click
    expect(page).to have_content('Performance Topic was deleted.')
    expect(page).not_to have_content(@performance_topic.title)
    expect(PerformanceTopic.count).to eq(0)
  end
end
