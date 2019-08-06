# To be able to use login_as(@user) in Rspec (Capybara especialy)
RSpec.configure do |config|
  config.include Warden::Test::Helpers
end
