require 'rails_helper'
include AdminHelpers

RSpec.feature 'Processing pending vacation requests as H.R' do
  before do
    @hr = create(:hr)
    @employee = create(:employee, vacation_balance: 20)
    assign_permission(@hr, :pending, VacationRequest)
    login_as(@hr, scope: :hr)
  end

  context 'when visiting pending requests' do
    it 'should list pending entries for all employees' do
      @vacation_request1 = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee)
      @vacation_request2 = create(:vacation_request, starts_on: Date.today + 8.days, ends_on: Date.today + 12.days, employee: @employee)
      @vacation_request3 = create(:vacation_request, starts_on: Date.today + 8.days, ends_on: Date.today + 10.days)

      visit pending_admin_vacation_requests_path

      expect(page).to have_content(@vacation_request1.ends_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@vacation_request2.ends_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@vacation_request3.ends_on.strftime('%d-%m-%Y'))
    end
  end

  scenario 'can approve the request' do
    assign_permission(@hr, :approve, VacationRequest)
    @vacation_request = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee, status: 1)

    visit pending_admin_vacation_requests_path

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Confirmed')

    find('.approve-link').click

    expect(Employee.employee.first.vacation_balance).to eq(18)
    expect(page).to have_content('Approved')
  end

  scenario 'can decline the request' do
    assign_permission(@hr, :decline, VacationRequest)
    @vacation_request = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee, status: 1)

    visit pending_admin_vacation_requests_path

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Confirmed')

    find('.decline-link').click

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Declined')
  end
end
