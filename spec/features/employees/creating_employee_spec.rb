require 'rails_helper'
include AdminHelpers

RSpec.feature 'Creating employee by H.R' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :create, Employee)
    visit new_admin_employee_path
  end

  scenario 'with valid data' do
    fill_in 'First Name', with: 'New'
    fill_in 'Last Name', with: 'Employee'
    fill_in 'Email', with: 'employee@test.com'
    fill_in 'Password', with: 'employeeemployee'
    fill_in 'Password Confirmation', with: 'employeeemployee'
    attach_file('Photo', File.absolute_path('./spec/support/test_image.jpg'))
    click_button 'Submit'
    
    expect(page).to have_content("#{Employee.first.full_name} has joined Fustany Team.")
    expect(page).to have_content(Employee.first.full_name)
  end

  scenario 'with invalid data' do
    fill_in 'First Name', with: ''
    fill_in 'Last Name', with: ''
    fill_in 'Email', with: ''
    fill_in 'Password', with: ''
    click_button 'Submit'
    
    expect(page).to have_content('First name can\'t be blank')
    expect(page).to have_content('Last name can\'t be blank')
    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
    expect(Employee.count).to eq(0)
  end

  scenario 'with duplicated data' do
    @employee = create(:employee)

    fill_in 'First Name', with: @employee.first_name
    fill_in 'Last Name', with: @employee.last_name
    fill_in 'Email', with: @employee.email
    fill_in 'Password', with: @employee.password
    fill_in 'Password Confirmation', with: @employee.password
    click_button 'Submit'
    
    expect(page).to have_content('Email has already been taken')
    expect(Employee.count).to eq(1)
  end
end
