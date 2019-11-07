FactoryBot.define do
  factory :timeline do
    content { Faker::Lorem.paragraph(8) }
    employee
  end
end
