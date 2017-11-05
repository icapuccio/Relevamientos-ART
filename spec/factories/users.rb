FactoryGirl.define do
  factory :user do
    email { Faker::Internet.email }
    password { Faker::Internet.password }
    password_confirmation { password }
    name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    role { %w(backoffice admin).sample }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    address { Faker:: Address.full_address }
  end

  trait :preventor do
    role { 'preventor' }
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    zone
  end
end
