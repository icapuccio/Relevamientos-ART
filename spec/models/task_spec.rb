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
      subject { create(:task, visit: visit, status: 'completed', task_type: :cap) }
      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end
    context 'its a cap task' do
      create(:task, visit: visit, status: 'pending', task_type: :cap )
      context 'and have not a cap result' do
        subject { create(:task, visit: visit, status: 'completed', task_type: :cap, completed_at: Faker::Date.forward ) }
        it 'returns an error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context 'and have a cap result without attendees' do
          let(:task) { create(:task, visit: visit, status: 'completed', task_type: :cap, completed_at: Faker::Date.forward ) }
          let(:cap_result) { create(:cap_result, task: task, attendees_count: 0) }
          subject do
        end
        it 'returns an error' do
          expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context 'and have a cap result with attendees' do
        subject do
          let(:task) { create(:task, visit: visit, status: 'completed', task_type: :cap, completed_at: Faker::Date.forward ) }
          let(:cap_result) { create(:cap_result, task: task, attendees_count: 1) }
        end
        context ' but have not the same number of employees' do
          it 'returns an error' do
            expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
          end
        end
        context ' and have the same number of employees' do
          subject do
            let(:task) { create(:task, visit: visit, status: 'completed', task_type: :cap, completed_at: Faker::Date.forward ) }
            let(:cap_result) { create(:cap_result, task: task, attendees_count: 1) }
            let(:cap_employee) { create(:cap_employee, cap_result: cap_result) }
          end
          it 'returns ok' do
            byebug
            expect { subject }.to change { Task.count }.by(+1)
          end
        end
      end
    end
  end
end
