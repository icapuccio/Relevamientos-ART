require 'rails_helper'

RSpec.describe CapResult, type: :model do
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:topic) }
  it { should validate_presence_of(:attendees_count) }
end
