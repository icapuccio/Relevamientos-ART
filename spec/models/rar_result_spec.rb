require 'rails_helper'

RSpec.describe RarResult, type: :model do
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:url_cloud) }
end
