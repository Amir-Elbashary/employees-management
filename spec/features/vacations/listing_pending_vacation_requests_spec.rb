require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing pending vacation requests as an H.R or supervisor' do
  before do
    initialize_app_settings
    @hr = create(:hr)
    @supervisor = create(:employee, level: 1)
    @employee = create(:employee, supervisor: @supervisor)
    @other_employee = create(:employee)

    @vacation_request1 = create(:vacation_request, requester: @employee)
    @vacation_request2 = create(:vacation_request, requester: @other_employee, starts_on: Date.today + 8.days, ends_on: Date.today + 10.days)
  end

  context 'when visiting as employee' do
    it 'should not allow you' do
      login_as(@employee, scope: :employee)
      visit pending_admin_vacation_requests_path

      expect(page).to have_content('You are not allowed!')
    end
  end

  context 'when visiting as supervisor' do
    it 'should list pending entries for employees under this supervisor only' do
      login_as(@supervisor, scope: :employee)
      visit pending_admin_vacation_requests_path

      expect(page).to have_content(@vacation_request1.ends_on.strftime('%d-%m-%Y'))
      expect(page).not_to have_content(@vacation_request2.ends_on.strftime('%d-%m-%Y'))
    end
  end

  context 'when visiting as H.R' do
    it 'should list pending entries for all employees' do
      assign_permission(@hr, :pending, VacationRequest)
      login_as(@hr, scope: :hr)
      visit pending_admin_vacation_requests_path

      expect(page).to have_content(@vacation_request1.ends_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@vacation_request2.ends_on.strftime('%d-%m-%Y'))
    end
  end
end
