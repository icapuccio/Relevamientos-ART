require 'rails_helper'

describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:role) }

  describe '#destroy' do
    let!(:user) { create(:user, :preventor) }

    subject { user.destroy }

    context 'without visits assigned' do
      it 'deletes the user' do
        expect { subject }.to change { User.count }.by(-1)
      end
    end

    context 'with visits assigned' do
      let!(:assigned_visit) { create(:visit, user: user) }

      it 'does not delete the user' do
        expect { subject }.to_not change { User.count }
      end

      it 'returns false' do
        expect(subject).to be false
      end
    end
  end
end
