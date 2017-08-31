require 'rails_helper'

describe Visit, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:priority) }
  context 'when the visit is in status pending' do
    it 'must not have the user and to_visit_on with values' do
      expect { let!(:visit) { create(:visit, :with_to_visit_on, status: 'pending') } }
        .to raise_error
      expect { let!(:visit2) { create(:visit, :with_user, status: 'pending') } }
        .to raise_error
    end
  end

  context 'when the visit is not in status pending' do
    it 'must not have the user and to_visit_on without values' do
      expect { let!(:visit) { create(:visit, :with_user, status: 'completed') } }
        .to raise_error
      expect { let!(:visit2) { create(:visit, :with_to_visit_on, status: 'assigned') } }
        .to raise_error
    end
  end
end
