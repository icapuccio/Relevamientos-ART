require 'rails_helper'

describe Visit, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:priority) }
  let!(:visit) { create(:visit, :with_user, status: 'pending') }

  context 'when the visit is in status pending' do
    let!(:visit) { create(:visit, status: 'pending') }
    it 'must have the user in nil' do
      expect(visit.user_id).to be_nil
    end
  end

  context 'when the visit is not in status pending' do
    let!(:visit) { create(:visit, :with_user, status: 'completed') }
    it 'must have the user with value' do
      expect(visit.user_id).not_to be_nil
    end
  end
end
