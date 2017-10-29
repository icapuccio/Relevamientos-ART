FactoryGirl.define do
  factory :cap_result do
    contents { Faker::ChuckNorris.fact }
    course_name { Faker::Yoda.quote }
    methodology { Faker::ChuckNorris.fact }
  end
end
