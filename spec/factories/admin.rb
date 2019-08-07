FactoryBot.define do
  factory :admin do
    email { 'admin@test.com' }
    password  { 'adminadmin' }
    first_name { 'Super' }
    last_name { 'Admin' }
    avatar { Faker::Avatar.image }
  end
end
