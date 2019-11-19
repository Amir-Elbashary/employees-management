require 'rails_helper'
include AdminHelpers

RSpec.feature 'Creating performance topic' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, PerformanceTopic)
    assign_permission(@hr, :create, PerformanceTopic)
    login_as(@hr, scope: :hr)
    visit new_admin_performance_topic_path
  end

  context 'with valid data' do
    it 'should add new performance topic' do
      fill_in 'Title', with: 'New Performance Topic'
      click_button 'Submit'
      
      expect(page).to have_content('Performance Topic has been added.')
      expect(PerformanceTopic.count).to eq(1)
      expect(page).to have_content(PerformanceTopic.first.title)
    end
  end

  context 'with invalid data' do
    it 'should not add topic with blank title' do
      fill_in 'Title', with: ''
      click_button 'Submit'
   
      expect(page).to have_content('Title can\'t be blank')
      expect(PerformanceTopic.count).to eq(0)
    end

    it 'should not add topic with duplicated data' do
      @performance_topic = create(:performance_topic)

      fill_in 'Title', with: @performance_topic.title
      click_button 'Submit'
   
      expect(page).to have_content('Title has already been taken')
      expect(PerformanceTopic.count).to eq(1)
    end
  end
end
