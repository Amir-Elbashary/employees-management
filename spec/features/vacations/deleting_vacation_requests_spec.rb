require 'rails_helper'

RSpec.feature 'Deleting vacation request' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @vacation_request = create(:vacation_request, requester: @employee)
    visit admin_vacation_requests_path
  end

  scenario 'should has list of Empty requests' do
    expect(VacationRequest.count).to eq(1)
    expect(page).to have_content(@vacation_request.starts_on.strftime('%d-%m-%Y'))

    find('.delete-link').click
    expect(page).to have_content('Request was deleted.')
    expect(VacationRequest.count).to eq(0)
    expect(page).not_to have_content(@vacation_request.starts_on.strftime('%d-%m-%Y'))
  end
end
