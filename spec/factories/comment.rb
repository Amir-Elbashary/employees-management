FactoryBot.define do
  factory :comment do
    content { Faker::Lorem.paragraph(8) }
    timeline
  end
end
