require 'rails_helper'
include AdminHelpers
include ActiveSupport::Testing::TimeHelpers

RSpec.feature 'Viewing leaderboard' do
  before do
    travel_to Time.zone.parse('2019-09-1')
    @hr = create(:hr)
    assign_permission(@hr, :read, PerformanceTopic)
    assign_permission(@hr, :create, Performance)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
    @another_employee = create(:employee)
    @performance_topic = create(:performance_topic)
    @performance = create(:performance, employee: @employee, year: 2019, month: 9, topic: @performance_topic.title, score: 4.0)
    @another_employee_performance = create(:performance, employee: @another_employee, year: 2019, month: 9, topic: @performance_topic.title, score: 3.5)
    visit admin_performance_topics_path
  end

  scenario 'visiting leaderboard' do
    find('.leaderboard-link').click
    fill_in 'year', with: 2019
    fill_in 'month', with: 9
    find('.period-submit').click

    expect(page).to have_content("1. #{@employee.full_name} scored: #{@performance.score}")
    expect(page).to have_content("2. #{@another_employee.full_name} scored: #{@another_employee_performance.score}")
  end
end
