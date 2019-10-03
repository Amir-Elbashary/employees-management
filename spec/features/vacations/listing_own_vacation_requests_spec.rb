require 'rails_helper'

RSpec.feature 'Listing your own vacation requests as an employee' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @vacation_request1 = create(:vacation_request, employee: @employee)
    @vacation_request2 = create(:vacation_request, starts_on: Date.today + 8.days, ends_on: Date.today + 10.days)
    visit admin_vacation_requests_path
  end

  scenario 'should has list of vacation requests' do
    expect(page).to have_content(@vacation_request1.starts_on.strftime('%d-%m-%Y'))
    expect(page).not_to have_content(@vacation_request2.starts_on.strftime('%d-%m-%Y'))
  end
end
