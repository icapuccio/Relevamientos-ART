FactoryGirl.define do
  factory :visit do
    priority { Faker::Number.number(2) }
    status { Visit.statuses.values.sample }
    institution
  end
  trait :with_user do
    user
  end
  trait :with_to_visit_on do
    to_visit_on { Faker::Date.forward }
  end
end
