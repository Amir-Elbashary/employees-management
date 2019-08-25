require 'rails_helper'

RSpec.feature 'Changing employee level' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
  end

  scenario 'by promoting to supervisor' do
    @employee = create(:employee)
    visit admin_employees_path

    expect(page).to have_content(@employee.full_name)
    expect(@employee.level).to eq('employee')
    expect(page).to have_link('Promote to supervisor')
    click_link('Promote to supervisor')

    expect(Employee.first.supervisor?).to eq(true)
  end

  scenario 'by demoting to employee' do
    @employee = create(:employee, level: 1)
    visit admin_employees_path

    expect(page).to have_content(@employee.full_name)
    expect(@employee.level).to eq('supervisor')
    expect(page).to have_link('Demote to employee')
    click_link('Demote to employee')

    expect(Employee.first.employee?).to eq(true)
  end
end
