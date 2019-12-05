require 'rails_helper'
include AdminHelpers
include ActiveSupport::Testing::TimeHelpers

RSpec.feature 'Checking employees birthdays' do
  before do
    travel_to Time.zone.parse('2019-02-20')
    @hr = create(:hr)
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :birthdays, Employee)
    assign_permission(@hr, :announce_birthday, Employee)
    @employee1 = create(:employee, birthdate: Date.parse('2019-02-25'))
    @employee2 = create(:employee, birthdate: Date.parse('2019-01-31'))
    login_as(@hr, scope: :hr)

    visit birthdays_admin_employees_path
  end

  context 'when there is no upcoming birthdays' do
    it 'should show disabled announce button' do
      expect(page).not_to have_css('.announce-link')
      expect(page).to have_css('.disabled-announce')
    end
  end

  context 'when there is upcoming birthday' do
    it 'should show enabled announce button' do
      travel_to Time.zone.parse('2019-02-25')
      visit birthdays_admin_employees_path

      expect(page).to have_css('.announce-link')
      expect(page).to have_css('.disabled-announce')
    end
  end

  context 'when announcing birthday' do
    it 'should post on timeline' do
      travel_to Time.zone.parse('2019-02-25')
      visit birthdays_admin_employees_path

      find('.announce-link').click

      expect(page).to have_content("You have announced #{@employee1.first_name}&#39;s birthday, Timeline post has been created and email was sent.")

      visit admin_path

      expect(page).to have_content("Happiest birthday #{@employee1.name}")
    end
  end
end
