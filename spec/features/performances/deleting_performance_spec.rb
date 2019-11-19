require 'rails_helper'
include AdminHelpers

RSpec.feature 'Deleting performance' do
  before do
    @hr = create(:hr)
    assign_permission(@hr, :read, Performance)
    assign_permission(@hr, :destroy, Performance)
    login_as(@hr, scope: :hr)
    @performance = create(:performance)
    visit admin_employee_performances_path(@performance.employee)
  end

  scenario 'should delete performance' do
    expect(page).to have_content(@performance.topic)
    expect(Performance.count).to eq(1)

    find('.delete-link').click
    expect(page).to have_content('Performance was deleted.')
    expect(page).not_to have_content(@performance.topic)
    expect(Performance.count).to eq(0)
  end
end
