require 'rails_helper'

RSpec.feature 'Commenting on timeline post' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    @other_employee = create(:employee)
    login_as(@employee, scope: :employee)
  end

  scenario '(own posts) with valid data' do
    @own_timeline = create(:timeline, publisher: @employee, kind: 1)
    visit admin_timeline_path(@own_timeline)
    expect(Notification.count).to eq(0)
    fill_in 'comment[content]', with: 'First comment'

    find('.comment-submit-btn').click
    
    expect(page).to have_content(Comment.first.content)
    expect(page).to have_content("last one by #{@employee.name}")
    expect(Notification.count).to eq(0)
  end

  scenario '(others posts) with valid data' do
    @timeline = create(:timeline, publisher: @other_employee, kind: 1)
    visit admin_timeline_path(@timeline)
    expect(Notification.count).to eq(0)
    fill_in 'comment[content]', with: 'First comment'

    find('.comment-submit-btn').click
    
    expect(page).to have_content(Comment.first.content)
    expect(page).to have_content("last one by #{@employee.name}")
    expect(Notification.count).to eq(1)
  end

  scenario 'with invalid data' do
    @timeline = create(:timeline, publisher: @other_employee, kind: 1)
    visit admin_timeline_path(@timeline)
    expect(Notification.count).to eq(0)
    fill_in 'comment[content]', with: ''

    find('.comment-submit-btn').click
    
    expect(page).to have_content('Content can&#39;t be blank')
    expect(Comment.count).to eq(0)
    expect(Notification.count).to eq(0)
  end

  scenario 'deleting comment' do
    @timeline = create(:timeline, publisher: @other_employee, kind: 1)
    visit admin_timeline_path(@timeline)
    create(:comment, timeline: @timeline, commenter: @employee)
    visit admin_path
    find('.comments-link').click
    expect(Comment.count).to eq(1)

    expect(page).to have_content(Comment.first.content)

    find('.comment-delete-link').click

    expect(Comment.count).to eq(0)
  end
end
