require 'rails_helper'

describe Visit, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:priority) }
  it { should validate_presence_of(:institution) }

  context 'when the visit is pending' do
    context 'with a user related' do
      subject { create(:visit, :with_user, status: 'pending') }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with a to visit on date assigned' do
      subject { create(:visit, status: 'pending', to_visit_on: Faker::Date.forward) }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'with the completed_at date assigned' do
      subject { create(:visit, status: 'pending', completed_at: Faker::Date.backward) }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when the visit is not pending' do
    context 'without to_visit_on date' do
      let(:user) { create(:user, :preventor) }

      subject { create(:visit, user: user, status: 'assigned') }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'without a user related' do
      subject { create(:visit, status: 'assigned', to_visit_on: Faker::Date.forward) }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when the visit is completed' do
    let(:user) { create(:user, :preventor) }
    let(:institution) { create(:institution, zone: user.zone) }

    context 'without completed_at date' do
      subject { create(:visit, user: user, status: 'completed') }
      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context '#destroy' do
    let!(:visit) { create(:visit) }
    let!(:task) { create(:task, visit: visit) }
    let!(:task2) { create(:task, visit: visit) }
    subject { visit.destroy }

    it 'deletes all their tasks' do
      expect { subject }.to change { Task.count }.by(-2)
    end
    it 'deletes the visit' do
      expect { subject }.to change { Visit.count }.by(-1)
    end
  end
end
