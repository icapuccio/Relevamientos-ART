FactoryGirl.define do
  factory :question do
    category { Faker::StarWars.character }
    description { Faker::StarWars.droid }
    answer { Faker::StarWars.vehicle }
    rgrl_result
  end
end
