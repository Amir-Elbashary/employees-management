require 'rails_helper'

RSpec.feature 'Reacting on timeline posts' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @timeline = create(:timeline, publisher: @employee, kind: 1)
    visit admin_timeline_path(@timeline)
  end

  scenario 'with Haha' do
    expect(React.count).to eq(0)

    find('.joy-btn').click
    
    expect(React.count).to eq(1)

    visit admin_timeline_path(@timeline)
    find('.love-btn').click
    
    expect(React.count).to eq(1)

    visit admin_timeline_path(@timeline)
    find('.love-btn').click
    
    expect(React.count).to eq(0)
  end
end
