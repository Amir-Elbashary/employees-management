FactoryBot.define do
  factory :vacation_request do
    starts_on { Date.today + 2.days }
    ends_on { Date.today + 4.days }
    reason { Faker::Lorem.paragraph(4) }
  end
end
