FactoryGirl.define do
  factory :worker do
    name { Faker::StarWars.character }
    last_name { Faker::StarWars.droid }
    cuil { Faker::StarWars.vehicle }
    sector { Faker::StarWars.planet }
    checked_in_on { Faker::Date.backward }
    exposed_from_at { Faker::Date.backward }
    exposed_until_at { Faker::Date.forward }
    rar_result
  end
end
