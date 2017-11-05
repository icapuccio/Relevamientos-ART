require 'rails_helper'

RSpec.describe VisitNoise, type: :model do
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:decibels) }
  it { should validate_presence_of(:visit) }
end
