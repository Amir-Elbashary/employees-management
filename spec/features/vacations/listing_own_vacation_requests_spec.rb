require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing vacation requests' do
  before do
    initialize_app_settings
    @admin = create(:admin)
    @hr = create(:hr)
    @employee = create(:employee)
    @other_employee = create(:employee)
    @employee_vacation_request = create(:vacation_request, requester: @employee)
    @others_vacation_request = create(:vacation_request, requester: @other_employee, starts_on: Date.today + 8.days, ends_on: Date.today + 10.days)
    @hr_vacation_request = create(:vacation_request, requester: @hr, starts_on: Date.today + 10.days, ends_on: Date.today + 12.days)
  end

  context 'as admin' do
    scenario 'should list all vacation requests' do
      login_as(@admin, scope: :admin)
      visit admin_vacation_requests_path

      expect(page).to have_content('Your Requests')
      expect(page).to have_content('All Vacation Requests')
      expect(page).to have_content(@employee_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@others_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@hr_vacation_request.starts_on.strftime('%d-%m-%Y'))
    end
  end

  context 'as H.R' do
    it 'should list own vacation requests only' do
      assign_permission(@hr, :read, VacationRequest)
      login_as(@hr, scope: :hr)
      visit admin_vacation_requests_path

      expect(page).to have_content('Your Requests')
      expect(page).not_to have_content('All Vacation Requests')
      expect(page).not_to have_content(@employee_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).not_to have_content(@others_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@hr_vacation_request.starts_on.strftime('%d-%m-%Y'))
    end
  end

  context 'as employee' do
    scenario 'should list own vacation requests only' do
      login_as(@employee, scope: :employee)
      visit admin_vacation_requests_path

      expect(page).to have_content('Your Requests')
      expect(page).not_to have_content('All Vacation Requests')
      expect(page).to have_content(@employee_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).not_to have_content(@others_vacation_request.starts_on.strftime('%d-%m-%Y'))
      expect(page).not_to have_content(@hr_vacation_request.starts_on.strftime('%d-%m-%Y'))
    end
  end
end
