require 'rails_helper'

RSpec.feature 'Changing employee state' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
  end

  scenario 'by activing him' do
    @employee = create(:employee, state: 0)
    visit admin_employees_path

    expect(page).to have_content(@employee.full_name)
    expect(@employee.state).to eq('inactive')
    expect(page).to have_link('Activate')
    click_link('Activate')

    expect(Employee.first.active?).to eq(true)
  end

  scenario 'by deactivating him' do
    @employee = create(:employee)
    visit admin_employees_path

    expect(page).to have_content(@employee.full_name)
    expect(@employee.state).to eq('active')
    expect(page).to have_link('Deactivate')
    click_link('Deactivate')

    expect(Employee.first.inactive?).to eq(true)
  end
end
