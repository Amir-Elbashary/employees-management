FactoryBot.define do
  factory :timeline do
    content { Faker::Lorem.paragraph(8) }
  end
end
