FactoryGirl.define do
  factory :visit do
    priority { Faker::Number.number(2) }
    status { 'pending' }
    institution
  end
  trait :with_user do
    status { %w(assigned in_process).sample }
    association :user, factory: [:user, :preventor]
    to_visit_on { Faker::Date.forward }
  end
  trait :completed do
    status { 'completed' }
    to_visit_on { Faker::Date.backward }
    completed_at { Faker::Date.backward }
  end
end
