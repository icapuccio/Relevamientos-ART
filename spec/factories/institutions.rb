FactoryGirl.define do
  factory :institution do
    name { Faker::GameOfThrones.house }
    cuit { Faker::Number.number(11) }
    street { Faker::Address.street_address }
    city { Faker::GameOfThrones.city }
    province { Faker::Address.city }
    number { Faker::Number.number(4) }
    activity { Faker::GameOfThrones.dragon }
    surface { Faker::Number.number(4) }
    workers_count { Faker::Number.number(4) }
    institutions_count { Faker::Number.number(4) }
    phone_number { Faker::Number.number(4) }
    contract { Faker::StarWars.planet }
    postal_code { Faker::Number.number(4) }
    longitude { Faker::Address.longitude }
    latitude { Faker::Address.latitude }
    address { Faker:: Address.full_address }
    contact { Faker:: GameOfThrones.character }
    email { Faker:: Internet.email }
    afip_cod { Faker:: GameOfThrones.dragon }
    ciiu { Faker::Number.number(5) }
    zone
  end
end
