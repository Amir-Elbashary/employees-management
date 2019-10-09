require 'rails_helper'
include AdminHelpers

RSpec.feature 'Generating employee report by H.R' do
  before do
    @admin = create(:admin)
    @hr = create(:hr) 
    assign_permission(@hr, :read, Employee)
    assign_permission(@hr, :read, Attendance)
    assign_permission(@hr, :append, Attendance)
    @employee = create(:employee)
  end

  describe 'Generating report for an employee' do
    context 'visiting reports page' do
      xit 'should show list of employees' do
      end
    end
  end
end
