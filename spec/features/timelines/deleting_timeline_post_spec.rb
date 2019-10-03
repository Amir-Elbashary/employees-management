require 'rails_helper'

RSpec.feature 'Deleting timeline post' do
  before do
    initialize_app_settings
    @employee = create(:employee)
    login_as(@employee, scope: :employee)
  end

  context 'if user own the post' do
    it 'should delete it from homepage timeline' do
      @timeline = create(:timeline, employee: @employee, kind: 1)
      visit admin_path

      expect(Timeline.count).to eq(1)
      expect(page).to have_content(@timeline.content)

      expect(page).to have_css('.delete-link')
      find('.delete-link').click
      expect(Timeline.count).to eq(0)
      expect(page).to have_content('Your post was deleted.')
      expect(page).not_to have_content(@timeline.content)
    end
  end

  context 'if user does not own the post' do
    it 'should not be able to see delete button' do
      @other_employee = create(:employee)
      @timeline = create(:timeline, employee: @other_employee, kind: 1)
      visit admin_path

      expect(Timeline.count).to eq(1)
      expect(page).to have_content(@timeline.content)

      expect(page).not_to have_css('.delete-link')
    end
  end
end
