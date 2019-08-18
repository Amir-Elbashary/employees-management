require 'rails_helper'
include AdminHelpers

RSpec.feature 'Accessing' do
  before do
    @hr = create(:hr)
    login_as(@hr, scope: :hr)
    @user = create(:user)
  end

  scenario 'index page while having no read permission' do
    visit admin_users_path
    expect(page).to have_content('You are not authorized to access this page')
  end

  scenario 'index while having read permission' do
    assign_permission(@hr, :read, User)
    visit admin_users_path
    expect(page).to have_content(@user.full_name)
  end

  scenario 'to delete while having no delete permission' do
    assign_permission(@hr, :read, User)
    visit admin_users_path
    expect(page).to have_content(@user.full_name)

    find('.delete-link').click
    expect(page).to have_content('You are not authorized to access this page')
    expect(User.count).to eq(1)
  end

  scenario 'to delete while having delete permission' do
    assign_permission(@hr, :read, User)
    assign_permission(@hr, :destroy, User)
    visit admin_users_path
    expect(page).to have_content(@user.full_name)

    find('.delete-link').click
    expect(page).not_to have_content('You are not authorized to access this page')
    expect(page).not_to have_content(@user.full_name)
    expect(User.count).to eq(0)
  end
end
