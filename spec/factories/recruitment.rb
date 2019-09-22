FactoryBot.define do
  factory :recruitment do
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    email { Faker::Internet.unique.email }
  end
end
