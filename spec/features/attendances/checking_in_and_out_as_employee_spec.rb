require 'rails_helper'

RSpec.feature 'Checking in/out by employees' do
  before do
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
  end

  describe 'verifying network' do
    context 'accessing from unauthorized network' do
      it 'should render unauthorized network page' do
        @settings = create(:setting)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).to have_content('Unauthorized network detected!')
      end
    end

    context 'accessing from unauthorized network while working from home' do
      it 'should render unauthorized network if request isn\'t approved by H.R' do
        @settings = create(:setting)
        @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today, ends_on: Date.today + 1.days, status: 1)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).to have_content('Unauthorized network detected!')
      end

      it 'should render attendances table if request is approved by H.R' do
        @settings = create(:setting)
        @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today, ends_on: Date.today + 1.days, status: 4)
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized network detected!')
      end
    end

    context 'accessing from authorized network' do
      it 'should render attendance table' do
        @settings = create(:setting, ip_addresses: ['127.0.0.1'])
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized network detected!')
      end
    end
  end

  describe 'should verify browser' do
    context 'accessing from unauthorized device' do
      it 'should render unauthorized devise page' do
        @settings = create(:setting, ip_addresses: ['127.0.0.1'])
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).to have_content('Unauthorized device detected!')
      end
    end

    context 'accessing from authorized device' do
      it 'should render attendance table' do
        @settings = create(:setting, ip_addresses: ['127.0.0.1'])
        logout(@employee)
        @admin = create(:admin)
        login_as(@admin, scope: :admin)
        visit admin_employees_path
        find('.grant-link').click
        logout(@admin)
        login_as(@employee, scope: :employee)
        visit admin_attendances_path
        visit admin_attendances_path

        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized device detected!')
      end
    end
  end

  context 'trying to checkout before checkin' do
    it 'should return error message' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-out!'

      expect(page).to have_content('You haven&#39;t check-in today yet, Let&#39;s start a productive day!')
    end
  end

  context 'cheking in for the first time' do
    it 'should check the employee in for today after authorizing network' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
    end

    it 'should bypass network authentication and check the employee in for today if he has approved work from home request' do
      @employee.update(access_token: 'secret-token')
      @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today, ends_on: Date.today + 1.days, status: 4)
      @settings = create(:setting)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
    end

    it 'should bypass network authentication and check the employee in for today if he has approved multiple days work from home request' do
      @employee.update(access_token: 'secret-token')
      @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today - 1.days, ends_on: Date.today + 1.days, status: 4)
      @settings = create(:setting)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
    end
  end

  context 'trying to cheking in multiple times' do
    it 'should not check employee again' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")

      checkin_time = Employee.first.attendances.first.updated_at

      click_link 'Check-in!'

      expect(page).to have_content("You have already checked-in today")
      expect(Employee.first.attendances.first.updated_at).to eq(checkin_time)
    end
  end

  context 'cheking out after checking in' do
    it 'should check the employee out for today after authenticating network' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).not_to eq(nil)
    end

    it 'should bypass network authenticating and check the employee out for today if work from home request is approved' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting)
      @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today, ends_on: Date.today + 1.days, status: 4)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).not_to eq(nil)
    end
  end

  context 'cheking out multiple times' do
    it 'should return checked out message already after authenticating network' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).not_to eq(nil)

      checkout_time = Employee.first.attendances.first.updated_at

      click_link 'Check-out!'

      expect(page).to have_content("You have already checked-out today")
      expect(Employee.first.attendances.first.updated_at).to eq(checkout_time)
    end

    it 'should return checked out message already after bypassing network authentication if work from home request is approved' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting)
      @vacation_request = create(:vacation_request, employee: @employee, kind: 1, starts_on: Date.today, ends_on: Date.today + 1.days, status: 4)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).not_to eq(nil)

      checkout_time = Employee.first.attendances.first.updated_at

      click_link 'Check-out!'

      expect(page).to have_content("You have already checked-out today")
      expect(Employee.first.attendances.first.updated_at).to eq(checkout_time)
    end
  end
end
