require 'rails_helper'

RSpec.describe 'Visiting dashboard', type: :request do
  context 'without being logged in' do
    it 'should redirect you to login page' do
      get '/admin'

      expect(response.code).to eq('302')
    end
  end

  context 'while logged in' do
    it 'should load admin dashboard while logging as admin' do
      @admin = create(:admin)
			login_as(@admin, scope: :admin)
      get '/admin'

      expect(response.code).to eq('200')
    end

    it 'should load admin dashboard while logging as H.R' do
      @hr = create(:hr)
			login_as(@hr, scope: :hr)
      get '/admin'

      expect(response.code).to eq('200')
    end
  end
end
