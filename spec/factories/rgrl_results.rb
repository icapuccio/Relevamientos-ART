FactoryGirl.define do
  factory :rgrl_result do
    task
    url_cloud { Faker::Internet.url }
  end
end
