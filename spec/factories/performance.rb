FactoryBot.define do
  factory :performance do
    topic { Faker::Name.unique.name }
    year { Faker::Number.between(2018,2020) }
    month { Faker::Number.between(1,12) }
    score { Faker::Number.between(1,4) }
    comment { Faker::Lorem.paragraph(4) }
    hr_comment { Faker::Lorem.paragraph(4) }
    employee
  end
end
