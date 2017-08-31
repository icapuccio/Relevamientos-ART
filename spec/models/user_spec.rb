require 'rails_helper'

describe User, type: :model do
  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:last_name) }
  it { should validate_presence_of(:role) }

  describe '#create' do
    let(:basic_attributes) { FactoryGirl.attributes_for(:user) }
    let!(:user_attributes) do
      user_attributes = basic_attributes
      user_attributes[:role] = role
      user_attributes
    end

    subject do
      User.create!(user_attributes)
    end

    context 'when the user is not an Admin' do
      let(:role) { 'backoffice' }

      it 'creates an user' do
        expect { subject }.to change { User.count }.by(1)
      end

      it 'does not create an admin user' do
        expect { subject }.to_not change { AdminUser.count }
      end
    end

    context 'when the user is an Admin' do
      let!(:role) { 'admin' }

      it 'creates an user' do
        expect { subject }.to change { User.count }.by(1)
      end

      it 'creates an admin user' do
        expect { subject }.to change { AdminUser.count }.by(1)
      end
    end
  end

  describe '#destroy' do
    context 'when validating visit association' do
      let!(:user) { create(:user, :preventor) }

      subject { user.destroy }

      context 'without visits assigned' do
        it 'deletes the user' do
          expect { subject }.to change { User.count }.by(-1)
        end
      end

      context 'with visits assigned' do
        let!(:assigned_visit) { create(:visit, :with_user, user: user) }

        it 'does not delete the user' do
          expect { subject }.to_not change { User.count }
        end

        it 'returns false' do
          expect(subject).to be false
        end
      end
    end

    context 'when validating admin user association' do
      context 'when the user is not an Admin' do
        let(:role) { 'backoffice' }
        let!(:user) { create(:user, role: role) }

        subject { user.destroy }

        it 'deletes the user' do
          expect { subject }.to change { User.count }.by(-1)
        end

        it 'does not delete any admin user' do
          expect { subject }.to_not change { AdminUser.count }
        end
      end

      context 'when the user is an Admin' do
        let(:role) { 'admin' }
        let!(:user) { create(:user, role: role) }

        subject { user.destroy }

        it 'deletes the user' do
          expect { subject }.to change { User.count }.by(-1)
        end

        it 'deletes the related admin user' do
          expect { subject }.to change { AdminUser.count }.by(-1)
        end
      end
    end
  end

  context 'when validating preventor data' do
    context 'when creating a preventor user without all required data' do
      subject { create(:user, role: 'preventor') }

      it 'returns an error' do
        expect { subject }.to raise_error(ActiveRecord::RecordInvalid)
      end
    end

    context 'when creating a preventor user with all required data' do
      let(:zone) { create(:zone) }

      subject do
        create(:user, role: 'preventor', latitude: -58.867, longitude: 67.586, zone: zone)
      end

      it 'does not fail' do
        expect { subject }.to_not raise_error
      end
    end
  end
end
