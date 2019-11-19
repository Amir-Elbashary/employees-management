require 'rails_helper'
include AdminHelpers

RSpec.feature 'Creating performance' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, Performance)
    assign_permission(@hr, :create, Performance)
    login_as(@hr, scope: :hr)
    @performance_topic = create(:performance_topic)
    @employee = create(:employee)
    visit new_admin_employee_performance_path(@employee)
  end

  context 'with valid data' do
    it 'should add new performance topic' do
      # This created performace to ensure uniquness
      # must fullfill topic, year and month
      @performance = create(:performance, employee: @employee, topic: @performance_topic.title, year: 2018, month: 10, score: 4.0)

      select(@performance_topic.title, from: 'performance[topic]').select_option
      select('2018', from: 'performance[year]').select_option
      select('September', from: 'performance[month]').select_option
      fill_in 'Score', with: 4
      fill_in 'Comment', with: 'You are great'
      fill_in 'Hr Comment', with: 'This is my private comment'
      click_button 'Submit'
      
      expect(page).to have_content('Performance has been added.')
      expect(Performance.count).to eq(2)
      expect(page).to have_content(Performance.first.year)
      expect(page).to have_content(Performance.first.score)
    end
  end

  context 'with invalid data' do
    it 'should not add topic with blank title' do
      fill_in 'Score', with: ''
      click_button 'Submit'
   
      expect(page).to have_content('Score can\'t be blank')
      expect(Performance.count).to eq(0)
    end

    it 'should not add topic with duplicated data' do
      @performance = create(:performance, employee: @employee, topic: @performance_topic.title, year: 2018, month: 9, score: 4.0)

      select(@performance_topic.title, from: 'performance[topic]').select_option
      select('2018', from: 'performance[year]').select_option
      select('September', from: 'performance[month]').select_option
      fill_in 'Score', with: 3
      click_button 'Submit'
   
      expect(page).to have_content('Performance on same period already exists')
      expect(PerformanceTopic.count).to eq(1)
    end
  end
end
