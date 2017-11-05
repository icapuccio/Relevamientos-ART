require 'rails_helper'

RSpec.describe VisitImage, type: :model do
  it { should validate_presence_of(:url_image) }
  it { should validate_presence_of(:visit) }
end
