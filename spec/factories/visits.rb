FactoryGirl.define do
  factory :visit do
    priority { Faker::Number.number(2) }
    status { Visit.statuses.values.sample }
  end

  trait :with_user do
    association :user, factory: [:user, :preventor]
  end
end
