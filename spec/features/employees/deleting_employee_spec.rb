require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting Employee' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :destroy, Employee)
    visit admin_employees_path
  end

  scenario 'should has list of Employees' do
    expect(Employee.count).to eq(1)
    expect(page).to have_content(@employee.full_name)

    find('.delete-link').click
    expect(page).to have_content('Employee was removed from Fustany Team.')
    expect(Employee.count).to eq(0)
    expect(page).not_to have_content(@employee.full_name)
  end
end
