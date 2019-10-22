FactoryBot.define do
  factory :message do
    subject { Faker::Lorem.paragraph(1) }
    content { Faker::Lorem.paragraph(2) }
  end
end
