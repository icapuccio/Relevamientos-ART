require 'rails_helper'

describe SessionsController, type: :controller do
  describe 'POST create' do
    let(:user) { create(:user, password: '12345678') }

    before(:each) do
      request.env['devise.mapping'] = Devise.mappings[:user]
      request.headers['Accept'] = 'application/json'
    end

    subject { post :create, params: { session: session_params } }

    context 'with invalid password' do
      let(:session_params) { { email: user.email, password: Faker::Internet.password } }

      before { subject }

      it 'responds with unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds a message pointing out that the credentials are incorrect' do
        expect(response_body['error']).to eq('invalid-credentials')
      end
    end

    context 'with invalid email' do
      let(:session_params) { { email: "a#{user.email}", password: user.password } }

      before { subject }

      it 'responds with unauthorized' do
        expect(response).to have_http_status(:unauthorized)
      end

      it 'responds a message pointing out that the credentials are incorrect' do
        expect(response_body['error']).to eq('invalid-credentials')
      end
    end

    context 'with valid email and password' do
      let(:session_params) { { email: user.email, password: user.password } }

      before { subject }

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns the id and email' do
        expect(response_body.keys).to contain_exactly('id', 'email')
      end
    end
  end
end
