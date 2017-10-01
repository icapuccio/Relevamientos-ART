FactoryGirl.define do
  factory :cap_result do
    topic { Faker::Yoda.quote }
    used_materials { Faker::ChuckNorris.fact }
    coordinators { Faker::StarWars.character }
    delivered_materials { Faker::ChuckNorris.fact }
  end
end
