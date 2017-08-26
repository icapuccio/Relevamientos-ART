FactoryGirl.define do
  factory :institution do
    name { Faker::GameOfThrones.house }
    cuit { Faker::GameOfThrones.character }
    address { Faker::Address.street_address }
    city { Faker::GameOfThrones.city }
    province { Faker::Address.city }
    number { Faker::Number.number(4) }
    activity { Faker::GameOfThrones.dragon }
    surface { Faker::Number.number(4) }
    workers_count { Faker::Number.number(4) }
    institutions_count { Faker::Number.number(4) }
    phone_number { Faker::PhoneNumber.phone_number }
  end
end
