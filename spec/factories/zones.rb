FactoryGirl.define do
  factory :zone do
    name { Faker::LordOfTheRings.location }
  end
end
