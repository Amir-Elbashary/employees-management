require 'rails_helper'
include AdminHelpers

RSpec.feature 'Generating employee report by H.R' do
  before do
    @admin = create(:admin)
    @hr = create(:hr) 
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :reports, Attendance)
    @employee = create(:employee)
    visit reports_admin_attendances_path
  end

  describe 'Generating report for an employee' do
    context 'visiting reports page' do
      it 'should show list of employees' do
        expect(page).to have_content(@employee.full_name)
      end
    end

    context 'clicking view report button' do
      it 'should ask for selecting date range' do
        click_link 'View Report'
        expect(page).to have_content('Please select date range')

        fill_in 'From', with: Date.today.at_beginning_of_month
        fill_in 'To', with: Date.today.at_end_of_month

        expect(page).to have_button('View Report')
      end
    end

    context 'select date range which has to attendances' do
      it 'should return no attendances message' do
        click_link 'View Report'
        expect(page).to have_content('Please select date range')

        fill_in 'From', with: Date.today.at_beginning_of_month
        fill_in 'To', with: Date.today.at_end_of_month
        click_button 'View Report'
        expect(page).to have_content('This employee has no attendances during the selected dates')
      end
    end

    context 'select date range which has at least one attendance' do
      it 'should load reports page' do
        @attendance = create(:attendance, employee: @employee)
        click_link 'View Report'
        expect(page).to have_content('Please select date range')

        fill_in 'From', with: Date.today.at_beginning_of_month
        fill_in 'To', with: Date.today.at_end_of_month
        click_button 'View Report'

        expect(page).to have_content('Attendance behavior compared with last month')
      end
    end
  end
end
