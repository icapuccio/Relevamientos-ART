require 'rails_helper'

RSpec.describe CapResult, type: :model do
  it { should validate_presence_of(:task) }
  it { should validate_presence_of(:methodology) }
  it { should validate_presence_of(:course_name) }
  it { should validate_presence_of(:contents) }
  it { should validate_presence_of(:url_cloud) }
end
