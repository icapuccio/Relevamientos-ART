FactoryGirl.define do
  factory :cap_result do
    topic { Faker::Yoda.quote }
    contents { Faker::ChuckNorris.fact }
    course_name { Faker::StarWars.character }
    methodology { Faker::ChuckNorris.fact }
  end
end
