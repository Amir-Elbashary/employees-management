FactoryBot.define do
  factory :notification do
    content { Faker::Lorem.paragraph(2) }
  end
end
