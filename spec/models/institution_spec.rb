require 'rails_helper'

describe Institution, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:province) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:surface) }
  it { should validate_presence_of(:workers_count) }
  it { should validate_presence_of(:institutions_count) }
end
