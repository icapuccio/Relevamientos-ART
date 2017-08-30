require 'rails_helper'

describe Visit, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:priority) }
  context 'when the visit is in status pending' do
    let!(:visit) { create(:visit, status: 'pending') }
    it 'must have the user and to_visit_on in nil' do
      expect(visit.user_id).to be_nil
      expect(visit.to_visit_on).to be_nil
    end
  end

  context 'when the visit is not in status pending' do
    let!(:visit) { create(:visit, :with_user, :with_to_visit_on, status: 'completed') }
    it 'must have the user and to_visit_on with values' do
      expect(visit.user_id).not_to be_nil
      expect(visit.to_visit_on).not_to be_nil
    end
  end
end
