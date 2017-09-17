require 'rails_helper'

describe Institution, type: :model do
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:address) }
  it { should validate_presence_of(:city) }
  it { should validate_presence_of(:province) }
  it { should validate_presence_of(:number) }
  it { should validate_presence_of(:surface) }
  it { should validate_presence_of(:workers_count) }
  it { should validate_presence_of(:cuit) }
  it { should validate_presence_of(:activity) }
  it { should validate_presence_of(:phone_number) }
  it { should validate_presence_of(:contract) }
  it { should validate_presence_of(:postal_code) }
  it { should validate_presence_of(:latitude) }
  it { should validate_presence_of(:longitude) }

  context '#destroy' do
    let!(:zone) { create(:zone) }
    let!(:institution) { create(:institution, zone: zone) }

    subject { institution.destroy }

    context 'without visits assigned' do
      it 'deletes the institution' do
        expect { subject }.to change { Institution.count }.by(-1)
      end
    end

    context 'with visits assigned' do
      let!(:user) { create(:user, zone: zone) }
      let!(:visit) do
        create(:visit, user: user, institution: institution, status: :assigned,
                       to_visit_on: Date.yesterday)
      end
      it 'does not delete the institution' do
        expect { subject }.to_not change { Institution.count }
      end

      it 'must return false' do
        expect(subject).to be false
      end
    end
  end
end
