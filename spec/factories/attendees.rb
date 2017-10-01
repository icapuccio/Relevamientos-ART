FactoryGirl.define do
  factory :attendee do
    name { Faker::StarWars.character }
    last_name { Faker::StarWars.droid }
    cuil { Faker::StarWars.vehicle }
    sector { Faker::StarWars.planet }
    cap_result
  end
end
