FactoryBot.define do
  factory :employee do
    email { Faker::Internet.unique.email }
    password  { 'employeeemployee' }
    first_name { Faker::Name.unique.name }
    last_name { Faker::Name.unique.name }
    avatar { Faker::Avatar.image }
  end
end
