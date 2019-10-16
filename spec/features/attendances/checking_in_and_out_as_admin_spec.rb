require 'rails_helper'

RSpec.feature 'Checking in/out by admin' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    visit admin_attendances_path
  end

  describe 'should not verify network first' do
    context 'accessing from unauthorized network' do
      it 'should be able to checkin' do
        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized network detected!')
      end
    end

    context 'accessing from authorized network' do
      it 'should render attendance table' do
        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized network detected!')
      end
    end
  end

  describe 'should not verify browser' do
    context 'accessing from unauthorized device' do
      it 'should be able to checkin' do
        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized device detected!')
      end
    end

    context 'accessing from authorized device' do
      it 'should render attendance table' do
        expect(page).to have_content('Attendance Sheet')
        expect(page).not_to have_content('Unauthorized device detected!')
      end
    end
  end

  context 'trying to checkout before checkin' do
    it 'should return error message' do
      click_link 'Check-out!'

      expect(page).to have_content('You haven&#39;t check-in today yet, Let&#39;s start a productive day!')
    end
  end

  context 'cheking in for the first time' do
    it 'should check the employee in for today' do
      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Admin.first.attendances.first.checkin).not_to eq(nil)
    end
  end

  context 'trying to cheking in multiple times' do
    it 'should not check employee again' do
      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")

      checkin_time = Admin.first.attendances.first.updated_at

      click_link 'Check-in!'

      expect(page).to have_content("You have already checked-in today")
      expect(Admin.first.attendances.first.updated_at).to eq(checkin_time)
    end
  end

  context 'cheking out after checking in' do
    it 'should check the employee in for today' do
      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Admin.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Admin.first.attendances.first.checkout).not_to eq(nil)
      expect(Admin.first.attendances.first.time_spent).not_to eq(nil)
    end
  end

  context 'cheking out multiple times' do
    it 'should check the employee in for today' do
      click_link 'Check-in!'

      expect(page).to have_content("Wishing you good and productive day.")
      expect(Admin.first.attendances.first.checkin).not_to eq(nil)

      click_link 'Check-out!'

      expect(page).to have_content("See you next day.")
      expect(Admin.first.attendances.first.checkout).not_to eq(nil)
      expect(Admin.first.attendances.first.time_spent).not_to eq(nil)

      checkout_time = Admin.first.attendances.first.updated_at

      click_link 'Check-out!'

      expect(page).to have_content("You have already checked-out today")
      expect(Admin.first.attendances.first.updated_at).to eq(checkout_time)
    end
  end
end
