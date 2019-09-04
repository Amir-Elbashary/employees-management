require 'rails_helper'

RSpec.feature 'Processing pending vacation requests as a supervisor' do
  before do
    @supervisor = create(:employee, level: 1)
    @employee = create(:employee, vacation_balance: 20, supervisor: @supervisor)
    login_as(@supervisor, scope: :employee)
  end

  context 'when visiting pending requests' do
    it 'should list pending entries for employees under this supervisor only' do
      @vacation_request1 = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee)
      @vacation_request2 = create(:vacation_request, starts_on: Date.today + 8.days, ends_on: Date.today + 12.days, employee: @employee)
      @vacation_request3 = create(:vacation_request, starts_on: Date.today + 8.days, ends_on: Date.today + 10.days)

      visit pending_admin_vacation_requests_path

      expect(page).to have_content(@vacation_request1.ends_on.strftime('%d-%m-%Y'))
      expect(page).to have_content(@vacation_request2.ends_on.strftime('%d-%m-%Y'))
      expect(page).not_to have_content(@vacation_request3.ends_on.strftime('%d-%m-%Y'))
    end
  end

  scenario 'can confirm the request' do
    @vacation_request = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee)

    visit pending_admin_vacation_requests_path

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Pending')

    find('.confirm-link').click

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Confirmed')
  end

  scenario 'can refuse the request' do
    @vacation_request = create(:vacation_request, starts_on: Date.today + 2.days, ends_on: Date.today + 4.days, employee: @employee)

    visit pending_admin_vacation_requests_path

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Pending')

    find('.refuse-link').click

    expect(Employee.employee.first.vacation_balance).to eq(20)
    expect(page).to have_content('Refused')
  end
end
