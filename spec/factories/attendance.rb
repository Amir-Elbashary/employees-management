FactoryBot.define do
  factory :attendance do
    checkin { Time.now }
    checkout { Time.now + 8.hours }
    time_spent { 8.0 }
    employee
  end
end
