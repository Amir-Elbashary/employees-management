FactoryBot.define do
  factory :performance_topic do
    title { Faker::Name.unique.name }
  end
end
