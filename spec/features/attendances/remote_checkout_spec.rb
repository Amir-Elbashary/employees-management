require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

RSpec.feature 'Remote checkout by clicking mail link' do
  before do
    travel_to Time.zone.parse('2019-09-23')
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
  end

  context 'clicking valid link' do
    it 'should check the employee out for today after authenticating network (Without remaning time)' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'], add_remaining_checkout_time: false)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      travel_to Time.zone.now + 2.minutes

      visit remote_checkout_admin_attendances_path(token: token)

      expect(Employee.first.attendances.first.checkout).to eq(Time.zone.now)
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to be >= 4
      expect(page).to have_content('You have checked-out successfully, See you next day :)')
    end

    it 'should check the employee out for today after authenticating network (With remaning time)' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'], add_remaining_checkout_time: true)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      travel_to Time.zone.now + 2.minutes

      visit remote_checkout_admin_attendances_path(token: token)

      expect(Employee.first.attendances.first.checkout).not_to eq(Time.zone.now)
      expect(Employee.first.attendances.first.checkout).to eq(Time.zone.now + 5.minutes)
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to be >= 4
      expect(page).to have_content('You have checked-out successfully, See you next day :)')
    end

    it 'should not check the employee out if he already checked out' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'], add_remaining_checkout_time: false)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      visit remote_checkout_admin_attendances_path(token: token)

      travel_to Time.zone.now + 2.minutes

      expect(Employee.first.attendances.first.checkout).to eq(Time.zone.now - 2.minutes)
      expect(Employee.first.attendances.first.checkout).not_to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to be >= 4
      expect(page).to have_content('You have checked-out successfully, See you next day :)')

      travel_to Time.zone.now + 1.minutes

      visit remote_checkout_admin_attendances_path(token: token)
      expect(page).to have_content('You have already checked-out today!')
    end

    it 'should not check the employee out if token is expired' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'], add_remaining_checkout_time: false)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      travel_to Time.zone.now + 10.minutes

      visit remote_checkout_admin_attendances_path(token: token)

      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)
      expect(page).to have_content('Token expired or invalid!, Please login to check-out.')
    end

    it 'should not check the employee out if token is invalid' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'], add_remaining_checkout_time: false)
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      visit remote_checkout_admin_attendances_path(token: 'invalid-token')

      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)
      expect(page).to have_content('Token expired or invalid!, Please login to check-out.')
    end

    it 'should not check the employee out for today via invalid network' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      travel_to (Time.now + 4.hours)

      Setting.first.update(ip_addresses: [])

      payload = {
        attendance_id: Employee.first.attendances.first.id,
        exp: (Time.zone.now + + 5.minutes).to_i
      }

      token = JWT.encode(payload, ENV['HMAC_SECRET'], 'HS256')

      visit remote_checkout_admin_attendances_path(token: token)

      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).not_to eq(4)
      expect(Employee.first.attendances.first.time_spent).to eq(0)
      expect(page).to have_content('Unauthorized network detected!, Please use any available authorized network then try again.')
    end
  end

  context 'clicking invalid link' do
    it 'should show expired token' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      visit remote_checkout_admin_attendances_path(token: 'invalid-token')

      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)
      expect(page).to have_content('Token expired or invalid!, Please login to check-out.')
    end
  end

  context 'visiting page without token' do
    it 'should show \'nothing to do\' message' do
      @employee.update(access_token: 'secret-token')
      @settings = create(:setting, ip_addresses: ['127.0.0.1'])
      page.driver.browser.set_cookie("ft_att_ver=#{@employee.access_token}")
      visit admin_attendances_path

      expect(page).to have_content(@employee.name)

      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Employee.first.attendances.first.checkin).not_to eq(nil)
      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)

      visit remote_checkout_admin_attendances_path

      expect(Employee.first.attendances.first.checkout).to eq(nil)
      expect(Employee.first.attendances.first.time_spent).to eq(0)
      expect(page).to have_content('There is nothing much to do here!')
    end
  end
end
