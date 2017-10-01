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
    context 'its a cap task' do
      let!(:task) { create(:task, visit: visit, status: 'pending', task_type: :cap) }
      let!(:completed_at) { DateTime.current }
      context 'and have not a cap result' do
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a cap result without employees' do
        let!(:cap_result) { create(:cap_result, task: task) }
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a cap result with employees' do
        let!(:cap_result) { create(:cap_result, task: task) }
        let!(:attendee) { create(:attendee, cap_result: cap_result) }
        it 'returns ok. change the status ' do
          expect { task.complete(completed_at) }.to change { task.status }
            .from('pending').to('completed')
        end
        it 'and complete the completed_at date' do
          expect { task.complete(completed_at) }.to change { task.completed_at }
            .from(nil).to(completed_at)
        end
      end
    end
    context 'its a rar task' do
      let!(:task) { create(:task, visit: visit, status: 'pending', task_type: :rar) }
      let!(:completed_at) { DateTime.current }
      context 'and have not a cap result' do
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a rar result without working_men' do
        let!(:rar_result) { create(:rar_result, task: task) }
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a rar result with working_man' do
        let!(:rar_result) { create(:rar_result, task: task) }
        let!(:worker) { create(:worker, rar_result: rar_result) }
        let!(:risk) { create(:risk, worker: worker) }
        it 'returns ok. change the status ' do
          expect { task.complete(completed_at) }.to change { task.status }
            .from('pending').to('completed')
        end
        it 'and complete the completed_at date' do
          expect { task.complete(completed_at) }.to change { task.completed_at }
            .from(nil).to(completed_at)
        end
      end
    end
    context 'its a rgrl task' do
      let!(:task) { create(:task, visit: visit, status: 'pending', task_type: :rgrl) }
      let!(:completed_at) { DateTime.current }
      context 'and have not a cap result' do
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a rgrl result without questions' do
        let!(:rgrl_result) { create(:rgrl_result, task: task) }
        it 'returns an error' do
          expect { task.complete(completed_at) }.to raise_error(ActiveRecord::RecordInvalid)
        end
      end
      context ', have a rgrl result with questions' do
        let!(:rgrl_result) { create(:rgrl_result, task: task) }
        let!(:question) { create(:question, rgrl_result: rgrl_result) }
        it 'returns ok. change the status ' do
          expect { task.complete(completed_at) }.to change { task.status }
            .from('pending').to('completed')
        end
        it 'and complete the completed_at date' do
          expect { task.complete(completed_at) }.to change { task.completed_at }
            .from(nil).to(completed_at)
        end
      end
    end
  end
end
