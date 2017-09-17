FactoryGirl.define do
  factory :cap_result do
    topic { Faker::Yoda.quote }
    attendees_count { Faker::Number.number(2) }
    used_materials { Faker::ChuckNorris.fact }
    delivered_materials { Faker::ChuckNorris.fact }
    cap_employee
  end
end
