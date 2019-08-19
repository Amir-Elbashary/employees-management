require 'rails_helper'
include AdminHelpers

RSpec.feature 'Listing H.Rs' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @employee1 = create(:employee)
    @employee2 = create(:employee)

    assign_permission(@hr, :read, Employee)
    visit admin_employees_path
  end

  scenario 'should has list of Employees' do
    expect(page).to have_content(@employee1.full_name)
    expect(page).to have_content(@employee2.full_name)
  end
end
