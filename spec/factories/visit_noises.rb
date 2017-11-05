FactoryGirl.define do
  factory :visit_noise do
    description { Faker::GameOfThrones.house }
    decibels { Faker::Number.decimal(2, 10).to_s }
    visit
  end
end
