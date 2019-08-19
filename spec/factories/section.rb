FactoryBot.define do
  factory :section do
    name { Faker::Name.unique.name }
  end
end
