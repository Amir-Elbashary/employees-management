require 'rails_helper'

RSpec.feature 'Creating timeline post' do
  before do
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    visit admin_path
  end

  scenario 'should appear on home page' do
    expect(Timeline.count).to eq(0)
    find('.modal-toggler').click

    fill_in 'Make your post pretty', with: 'Post content'

    click_button 'Share'

    expect(Timeline.count).to eq(1)
    expect(page).to have_content(Timeline.first.content)
  end
end
