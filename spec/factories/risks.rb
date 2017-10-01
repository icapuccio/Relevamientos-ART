FactoryGirl.define do
  factory :risk do
    description { Faker::Yoda.quote }
    worker
  end
end
