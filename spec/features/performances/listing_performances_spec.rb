require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing performances' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, Performance)
    login_as(@hr, scope: :hr)
    @employee = create(:employee)
    @performance1 = create(:performance, employee: @employee)
    @performance2 = create(:performance, employee: @employee)
    visit admin_employee_performances_path(@employee)
  end

  scenario 'should has list of performances' do
    expect(page).to have_content(@performance1.year)
    expect(page).to have_content(@performance2.score)
  end
end
