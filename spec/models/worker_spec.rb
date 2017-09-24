require 'rails_helper'

RSpec.describe Worker, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:cuil) }
  it { should validate_presence_of(:rar_result_id) }
end
