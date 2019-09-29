require 'rails_helper'
include AdminHelpers

RSpec.feature 'appending checkins by admin or H.R' do
  before do
    @admin = create(:admin)
    @hr = create(:hr) 
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :read, Attendance)
    assign_permission(@hr, :append, Attendance)
    @employee = create(:employee)
  end

  describe 'Appending checkin as admin' do
    context 'while employee has not checked in' do
      it 'should be able to check employee in' do
        login_as(@admin, scope: :admin)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-in', from: 'Action').select_option
        fill_in 'Date and Time', with: Time.zone.now

        click_button('Append')

        expect(page).to have_content('Check-in appended')

        visit admin_employees_path
        find('.grant-link').click
        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('Still working...')
        expect(Employee.first.attendances.first.checkout).to eq(nil)
      end
    end

    context 'while employee already checked in' do
      it 'should not be able to check him in again' do
        login_as(@admin, scope: :admin)
        create(:attendance, employee: @employee, checkin: Time.zone.now, checkout: nil, time_spent: nil)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-in', from: 'Action').select_option
        fill_in 'Date and Time', with: Time.zone.now + 2.hours

        click_button('Append')

        expect(page).to have_content('Employee already checked-in')

        visit admin_employees_path
        find('.grant-link').click
        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('Still working...')
        expect(Employee.first.attendances.first.checkout).to eq(nil)
      end
    end
  end

  describe 'Appending checkout as admin' do
    context 'while employee has not checked out' do
      it 'should be able to check employee out' do
        checkin_time = Time.zone.now
        create(:attendance, employee: @employee, checkin: checkin_time, checkout: nil, time_spent: nil)
        login_as(@admin, scope: :admin)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-out', from: 'Action').select_option
        fill_in 'Date and Time', with: checkin_time + 4.hours

        click_button('Append')

        expect(page).to have_content('Check-out appended')

        visit admin_employees_path
        find('.grant-link').click
        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).not_to have_content('Still working...')
        expect(page).to have_content('4.0')
        expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      end
    end

    context 'while employee already checked out' do
      it 'should not be able to check him out again' do
        login_as(@admin, scope: :admin)
        checkin_time = Time.zone.now
        create(:attendance, employee: @employee, checkin: checkin_time, checkout: checkin_time + 4.hours, time_spent: 4)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-out', from: 'Action').select_option
        fill_in 'Date and Time', with: checkin_time + 5.hours

        click_button('Append')

        expect(page).to have_content('Employee already checked-out')

        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('4.0')
        expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      end
    end

    context 'while employee has no check-in during that day' do
      it 'should return employee has not checked in that day' do
        checkin_time = Time.zone.now
        login_as(@admin, scope: :admin)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-out', from: 'Action').select_option
        fill_in 'Date and Time', with: checkin_time + 4.hours

        click_button('Append')

        expect(page).to have_content('Employee has not checked-in during selected day')

        visit admin_employees_path
        find('.grant-link').click
        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.count).to eq(0)
      end
    end
  end

  describe 'Appending checkin as H.R' do
    context 'while employee has not checked in' do
      it 'should be able to check employee in' do
        login_as(@hr, scope: :hr)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-in', from: 'Action').select_option
        fill_in 'Date and Time', with: Time.zone.now

        click_button('Append')

        expect(page).to have_content('Check-in appended')

        visit admin_employees_path
        find('.grant-link').click
        logout(@hr)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('Still working...')
        expect(Employee.first.attendances.first.checkout).to eq(nil)
      end
    end

    context 'while employee already checked in' do
      it 'should not be able to check him in again' do
        login_as(@hr, scope: :hr)
        create(:attendance, employee: @employee, checkin: Time.zone.now, checkout: nil, time_spent: nil)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-in', from: 'Action').select_option
        fill_in 'Date and Time', with: Time.zone.now + 2.hours

        click_button('Append')

        expect(page).to have_content('Employee already checked-in')

        logout(@hr)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('Still working...')
        expect(Employee.first.attendances.first.checkout).to eq(nil)
      end
    end
  end

  describe 'Appending checkout as H.R' do
    context 'while employee has not checked out' do
      it 'should be able to check employee out' do
        checkin_time = Time.zone.now
        create(:attendance, employee: @employee, checkin: checkin_time, checkout: nil, time_spent: nil)
        login_as(@hr, scope: :hr)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-out', from: 'Action').select_option
        fill_in 'Date and Time', with: checkin_time + 4.hours

        click_button('Append')

        expect(page).to have_content('Check-out appended')

        visit admin_employees_path
        find('.grant-link').click
        logout(@hr)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).not_to have_content('Still working...')
        expect(page).to have_content('4.0')
        expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      end
    end

    context 'while employee already checked out' do
      it 'should not be able to check him out again' do
        login_as(@hr, scope: :hr)
        checkin_time = Time.zone.now
        create(:attendance, employee: @employee, checkin: checkin_time, checkout: checkin_time + 4.hours, time_spent: 4)
        visit admin_attendances_path
        
        select(@employee.full_name, from: 'Employee').select_option
        select('Check-out', from: 'Action').select_option
        fill_in 'Date and Time', with: checkin_time + 5.hours

        click_button('Append')

        expect(page).to have_content('Employee already checked-out')

        logout(@hr)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(Employee.first.attendances.first.checkin).not_to eq(nil)
        expect(page).to have_content('4.0')
        expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      end
    end
  end
end
