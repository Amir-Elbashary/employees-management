require 'rails_helper'

RSpec.feature 'Creating role' do
  before do
    @admin = create(:admin)
    login_as(@admin, scope: :admin)
    @create_permission = Permission.create(target_model_name: 'User', action: 'create')
    @read_permission = Permission.create(target_model_name: 'User', action: 'read')
    @update_permission = Permission.create(target_model_name: 'User', action: 'update')
    @delete_permission = Permission.create(target_model_name: 'User', action: 'destroy')
    @hr1 = create(:hr)
    @hr2 = create(:hr)
    visit new_admin_role_path
  end

  scenario 'with valid data' do
    fill_in 'Name', with: 'Creating'
    click_button 'Submit'
    
    expect(page).to have_content('Role has been successfully added.')
    expect(page).to have_content('Creating')
  end

  scenario 'with invalid data' do
    fill_in 'Name', with: ''
    click_button 'Submit'
    
    expect(page).to have_content('Name can\'t be blank')
  end

  scenario 'with duplicated data' do
    @role = create(:role)

    fill_in 'Name', with: @role.name
    click_button 'Submit'
    
    expect(page).to have_content('Name has already been taken')
  end

  scenario 'with permissions included' do
    expect(page).to have_content('Create User')
    expect(page).to have_content('Read User')
    expect(page).to have_content('Update User')
    expect(page).to have_content('Destroy User')
    expect(page).to have_content(@hr1.full_name)
    expect(page).to have_content(@hr2.full_name)
    @hr1_ability = Ability.new(@hr1)

    expect(@hr1_ability).not_to be_able_to(:destroy, User)

    fill_in 'Name', with: 'Deleting User'
    check(@delete_permission.name)
    check(@update_permission.name)
    check(@hr1.full_name)

    click_button('Submit')

    @hr1_ability = Ability.new(Hr.find_by(email: @hr1.email))
    @hr2_ability = Ability.new(Hr.find_by(email: @hr2.email))
    expect(@hr1_ability).not_to be_able_to(:create, User)
    expect(@hr1_ability).not_to be_able_to(:read, User)
    expect(@hr1_ability).to be_able_to(:update, User)
    expect(@hr1_ability).to be_able_to(:destroy, User)
    expect(@hr2_ability).not_to be_able_to(:create, User)
    expect(@hr2_ability).not_to be_able_to(:read, User)
    expect(@hr2_ability).not_to be_able_to(:update, User)
    expect(@hr2_ability).not_to be_able_to(:destroy, User)
  end
end
