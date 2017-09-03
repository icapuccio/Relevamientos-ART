require 'rails_helper'

RSpec.describe Task, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:task_type) }
  it { should validate_presence_of(:visit) }

  context 'when the task is pending' do
    let!(:visit) { create(:visit, status: 'pending') }
    context 'with a completed_at assigned' do
      subject { create(:task, status: 'pending', visit: visit, completed_at: Faker::Date.forward) }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when the task is completed' do
    let(:user) { create(:user, :preventor) }
    let!(:visit) do
      create(:visit, :completed, user: user)
    end

    context 'without completed_at date' do
      subject { create(:task, visit: visit, status: 'completed') }
      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
