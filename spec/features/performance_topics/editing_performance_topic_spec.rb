require 'rails_helper'
include AdminHelpers

RSpec.feature 'Editing performance topic' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, PerformanceTopic)
    assign_permission(@hr, :update, PerformanceTopic)
    login_as(@hr, scope: :hr)
    @performance_topic = create(:performance_topic)
    visit edit_admin_performance_topic_path(@performance_topic)
  end

  context 'with valid data' do
    it 'should modify performance topic info' do
      fill_in 'Title', with: 'New awesome topic'
      click_button 'Submit'
      
      expect(page).to have_content('Changes has been saved')
      expect(PerformanceTopic.first.title).to eq('New awesome topic')
    end
  end


  context 'with invalid data' do
    it 'should not update performance topic' do
      fill_in 'Title', with: ''
      click_button 'Submit'

      expect(page).to have_content('Title can\'t be blank')
    end
  end

  context 'with duplicated data' do
    it 'should not update performance topic' do
      performance_topic = create(:performance_topic)

      fill_in 'Title', with: performance_topic.title
      click_button 'Submit'
      
      expect(page).to have_content('Title has already been taken')
    end
  end
end
