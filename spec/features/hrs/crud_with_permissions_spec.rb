require 'rails_helper'
include AdminHelpers

RSpec.feature 'Accessing' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
  end

  scenario 'index page while having no read permission' do
    visit admin_employees_path
    expect(page).to have_content('You are not authorized to access this page')
  end

  scenario 'index while having read permission' do
    assign_permission(@hr, :read, Employee)
    visit admin_employees_path
    expect(page).to have_content(@employee.full_name)
  end

  scenario 'to delete while having no delete permission' do
    assign_permission(@hr, :read, Employee)
    visit admin_employees_path
    expect(page).to have_content(@employee.full_name)

    find('.delete-link').click
    expect(page).to have_content('You are not authorized to access this page')
    expect(Employee.count).to eq(1)
  end

  scenario 'to delete while having delete permission' do
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :destroy, Employee)
    visit admin_employees_path
    expect(page).to have_content(@employee.full_name)

    find('.delete-link').click
    expect(page).not_to have_content('You are not authorized to access this page')
    expect(page).not_to have_content(@employee.full_name)
    expect(Employee.count).to eq(0)
  end
end
