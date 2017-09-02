FactoryGirl.define do
  factory :task do
    task_type { %w(cap rar rgrl).sample }
    status { 'pending' }
    visit
  end
end
