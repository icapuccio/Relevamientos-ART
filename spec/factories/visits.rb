FactoryGirl.define do
  factory :visit do
    priority { Faker::Number.number(2) }
    status { 'pending' }
    institution
    external_id { Faker::Number.number(4) }
  end
  trait :with_user do
    status { %w(assigned in_process).sample }
    association :user, factory: [:user, :preventor]
    to_visit_on { Faker::Date.forward }
    institution { create(:institution, zone: user.zone) }
    external_id { Faker::Number.number(4) }
  end
  trait :completed do
    status { 'completed' }
    to_visit_on { Faker::Date.backward }
    completed_at { Faker::Date.backward }
    external_id { Faker::Number.number(4) }
  end
end
