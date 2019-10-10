require 'rails_helper'
include AdminHelpers

RSpec.feature 'Creating holiday' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Holiday)
    assign_permission(@hr, :create, Holiday)
    assign_permission(@hr, :update, Holiday)
    visit new_admin_holiday_path
  end

  scenario 'with valid data' do
    fill_in 'Name', with: 'Special Holiday'
    fill_in 'Content', with: 'The most awated day'
    fill_in 'Year', with: 2019
    fill_in 'Month', with: 9
    fill_in 'Duration', with: 4
    fill_in 'Starts on', with: '19/9/1990'
    click_button 'Submit and Announce'
    
    expect(page).to have_content('Holiday has been added and announced.')
    expect(Holiday.count).to eq(1)
    expect(page).to have_content(Holiday.first.name)
    expect(Holiday.first.ends_on).to eq(Holiday.first.starts_on + 4.days)

    visit admin_path
    expect(page).to have_content(Holiday.first.content)
  end

  scenario 'with duplicated data' do
    @holiday = create(:holiday, year: 2019, month: 9, starts_on: '19/9/1990'.to_datetime)

    fill_in 'Name', with: 'Special Holiday'
    fill_in 'Content', with: 'The most awated day'
    fill_in 'Year', with: 2019
    fill_in 'Month', with: 9
    fill_in 'Duration', with: 4
    fill_in 'Starts on', with: '19/9/1990'
    click_button 'Submit and Announce'
    
    expect(page).to have_content('Holiday already exists')
    expect(Holiday.count).to eq(1)
  end
end
