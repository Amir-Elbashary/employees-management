require 'rails_helper'

RSpec.feature 'Editing vacation requests' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @vacation_request = create(:vacation_request, employee: @employee)
    @others_request = create(:vacation_request)
  end

  describe 'with valid data' do
    context 'when editing your own request' do
      it 'should update your request' do
        visit edit_admin_vacation_request_path(@vacation_request)

        fill_in 'Starts on', with: (Date.today + 4.days)
        fill_in 'Ends on', with: (Date.today + 8.days)
        fill_in 'Reason', with: 'New reason'

        click_button 'Submit'
        
        expect(page).to have_content('Request has been updated.')
        expect(VacationRequest.last.reason).to eq('New reason')
      end
    end

    context 'when editing other\'s request' do
      it 'should not allow it and get redirected' do
        visit edit_admin_vacation_request_path(@others_request)
      
        expect(page).to have_content('You are not allowed!')
        expect(VacationRequest.first.reason).to eq(@others_request.reason)
      end
    end
  end


  describe 'with invalid data' do
    context 'without required fields' do
      it 'should not submit the request' do
        visit edit_admin_vacation_request_path(@vacation_request)

        fill_in 'Starts on', with: ''
        fill_in 'Ends on', with: ''
        fill_in 'Reason', with: ''

        click_button 'Submit'

        expect(page).to have_content('Starts on can\'t be blank')
        expect(page).to have_content('Ends on can\'t be blank')
        expect(page).to have_content('Reason can\'t be blank')
      end
    end

    context 'with end date before start date' do
      it 'should not submit the request' do
        visit edit_admin_vacation_request_path(@vacation_request)

        fill_in 'Starts on', with: (Date.today + 4.days)
        fill_in 'Ends on', with: (Date.today + 2.days)
        fill_in 'Reason', with: 'I just need a vacation :P'

        click_button 'Submit'
        
        expect(page).to have_content('End date can not be before or equals to start date.')
      end
    end
  end
end
