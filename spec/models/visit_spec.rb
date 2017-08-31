require 'rails_helper'

describe Visit, type: :model do
  it { should validate_presence_of(:status) }
  it { should validate_presence_of(:priority) }
  it { should validate_presence_of(:institution) }
  context 'when the visit is in status pending' do
    context 'and a user has been assigned' do
      subject { create(:visit, :with_user, status: 'pending') }
      it 'must raise a RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context 'and have to_visit_on with value' do
      subject { create(:visit, :with_to_visit_on, status: 'pending') }
      it 'must raise a RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end

  context 'when the visit is not in status pending' do
    context 'and have to_visit_on without value' do
      subject { create(:visit, :with_user, status: 'assigned') }
      it 'must raise a RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context 'and a user has not been assigned' do
      subject { create(:visit, :with_to_visit_on, status: 'completed') }
      it 'must raise a RecordInvalid error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
  end
end
