FactoryBot.define do
  factory :update do
    version { Faker::Number.between(1.0, 8.4).round(2) }
    changelog { Faker::Lorem.paragraph(8) }
  end
end
