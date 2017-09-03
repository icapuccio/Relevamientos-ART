FactoryGirl.define do
  factory :task do
    task_type { Task.task_types.values.sample }
    status { 'pending' }
    visit
  end
end
