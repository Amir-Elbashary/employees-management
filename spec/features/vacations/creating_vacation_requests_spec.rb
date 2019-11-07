require 'rails_helper'

RSpec.feature 'Creating vacation request' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    visit new_admin_vacation_request_path
  end

  scenario 'with valid data' do
    fill_in 'Starts on', with: (Date.today + 2.days)
    fill_in 'Back to work on', with: (Date.today + 4.days)
    select('Vacation', from: 'Type').select_option
    fill_in 'Reason', with: 'I just need a vacation :P'

    click_button 'Submit'
    
    expect(page).to have_content('Request has been submitted.')
    expect(page).to have_content(VacationRequest.first.starts_on.strftime('%d-%m-%Y'))
    expect(VacationRequest.count).to eq(1)
  end

  describe 'with invalid data' do
    context 'without required fields' do
      it 'should not submit the request' do
        fill_in 'Starts on', with: ''
        fill_in 'Back to work on', with: ''
        select('Vacation', from: 'Type').select_option
        fill_in 'Reason', with: ''

        click_button 'Submit'
        
        expect(page).to have_content('Starts on can\'t be blank')
        expect(page).to have_content('Ends on can\'t be blank')
        expect(page).to have_content('Reason can\'t be blank')
        expect(VacationRequest.count).to eq(0)
      end
    end

    context 'with end date before start date' do
      it 'should not submit the request' do
        fill_in 'Starts on', with: (Date.today + 4.days)
        fill_in 'Back to work on', with: (Date.today + 2.days)
        select('Vacation', from: 'Type').select_option
        fill_in 'Reason', with: 'I just need a vacation :P'

        click_button 'Submit'
        
        expect(page).to have_content('End date can not be before or equals to start date.')
        expect(VacationRequest.count).to eq(0)
      end
    end
  end
end
