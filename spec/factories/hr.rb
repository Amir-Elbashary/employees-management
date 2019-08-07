FactoryBot.define do
  factory :hr do
    email { 'hr@test.com' }
    password  { 'hrhrhrhr' }
    first_name { 'Human' }
    last_name { 'Resources' }
    avatar { Faker::Avatar.image }
  end
end
