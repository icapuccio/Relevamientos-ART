require 'rails_helper'

RSpec.describe Question, type: :model do
  it { should validate_presence_of(:category) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:answer) }
  it { should validate_presence_of(:rgrl_result_id) }
end
