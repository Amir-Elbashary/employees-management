FactoryBot.define do
  factory :holiday do
    name { Faker::Name.unique.name }
    content { Faker::Lorem.paragraph(8) }
    year { Faker::Number.between(2010, 2020) }
    month { Faker::Number.between(1, 12) }
    duration { Faker::Number.between(2,8) }
    starts_on { Faker::Date.between(Date.today - 2.years, Date.today) }
  end
end
