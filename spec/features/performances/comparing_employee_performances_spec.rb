require 'rails_helper'
include AdminHelpers
include ActiveSupport::Testing::TimeHelpers

RSpec.feature 'Comparing performance' do
  before do
    travel_to Time.zone.parse('2019-09-1')
    @hr = create(:hr)
    assign_permission(@hr, :manage, Employee)
    assign_permission(@hr, :manage, Performance)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
    @performance_topic = create(:performance_topic)
    @performance = create(:performance, employee: @employee, year: 2019, month: 9, topic: @performance_topic.title, score: 4.0)
    @step_up_performance = create(:performance, employee: @employee, year: 2019, month: 10, topic: @performance_topic.title, score: 4.5)
    @step_back_performance = create(:performance, employee: @employee, year: 2019, month: 11, topic: @performance_topic.title, score: 3.0)
    visit admin_employees_path
  end

  scenario 'checking yearly performances' do
    find('.yearly-performance-link').click
    expect(page).to have_content("Topic: #{@performance_topic.title}")
    expect(page).to have_content('No Performance Appraisals found for this month')
  end

  context 'comparing employee performances' do
    it 'should not compare future with past' do
      find('.comparing-link').click
      fill_in 'year_from', with: 2019
      fill_in 'month_from', with: 10
      fill_in 'year_to', with: 2019
      fill_in 'month_to', with: 9
      find('.compare-submit').click

      expect(page).to have_content('Please compare past with future')
    end

    it 'should compare past with future (Better)' do
      find('.comparing-link').click
      fill_in 'year_from', with: 2019
      fill_in 'month_from', with: 9
      fill_in 'year_to', with: 2019
      fill_in 'month_to', with: 10
      find('.compare-submit').click
      select(@performance_topic.title, from: 'topic').select_option
      find('.comparison-submit').click

      expect(page).to have_content('Step Up!')
    end

    it 'should compare past with future (Worse)' do
      find('.comparing-link').click
      fill_in 'year_from', with: 2019
      fill_in 'month_from', with: 10
      fill_in 'year_to', with: 2019
      fill_in 'month_to', with: 11
      find('.compare-submit').click
      select(@performance_topic.title, from: 'topic').select_option
      find('.comparison-submit').click

      expect(page).to have_content('Step Back!')
    end
  end
end

