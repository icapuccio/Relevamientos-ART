require 'rails_helper'

RSpec.describe Zone, type: :model do
  it { should validate_presence_of(:name) }

  context '#destroy' do
    let!(:zone) { create(:zone) }

    subject { zone.destroy }

    context 'when validating users association' do
      context 'without users assigned' do
        it 'deletes the zone' do
          expect { subject }.to change { Zone.count }.by(-1)
        end
      end

      context 'with users assigned' do
        let!(:user) { create(:user, zone: zone) }

        it 'does not delete the Zone' do
          expect { subject }.to_not change { Zone.count }
        end

        it 'must return false' do
          expect(subject).to be false
        end
      end
    end
    context 'when validating institutions association' do
      context 'without institutions assigned' do
        it 'deletes the zone' do
          expect { subject }.to change { Zone.count }.by(-1)
        end
      end
      context 'with institutions assigned' do
        let!(:institution) { create(:institution, zone: zone) }

        it 'does not delete the Zone' do
          expect { subject }.to_not change { Zone.count }
        end

        it 'must return false' do
          expect(subject).to be false
        end
      end
    end
  end
end
