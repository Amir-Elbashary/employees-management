FactoryBot.define do
  factory :hr do
    email { Faker::Internet.unique.email }
    password  { 'hrhrhrhr' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }
  end
end
