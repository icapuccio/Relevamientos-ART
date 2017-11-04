FactoryGirl.define do
  factory :visit_image do
    url_image { Faker::StarWars.character }
    visit
  end
end
