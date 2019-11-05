require 'rails_helper'

RSpec.feature 'Commenting on timeline post' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
    @timeline = create(:timeline, employee: @employee, kind: 1)
    visit admin_timeline_path(@timeline)
  end

  scenario 'with valid data' do
    fill_in 'comment[content]', with: 'First comment'

    click_button 'Post'
    
    expect(page).to have_content(Comment.first.content)
    expect(page).to have_content("last one by #{@employee.name}")
  end

  scenario 'with invalid data' do
    fill_in 'comment[content]', with: ''

    click_button 'Post'
    
    expect(page).to have_content('Content can&#39;t be blank')
    expect(Comment.count).to eq(0)
  end

  scenario 'deleting comment' do
    create(:comment, timeline: @timeline, employee: @employee)
    visit admin_path
    find('.comments-link').click
    expect(Comment.count).to eq(1)

    expect(page).to have_content(Comment.first.content)

    find('.comment-delete-link').click

    expect(Comment.count).to eq(0)
  end
end
