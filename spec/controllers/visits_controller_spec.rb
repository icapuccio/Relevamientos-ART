require 'rails_helper'

describe VisitsController, type: :controller do
  let(:user_1) { create(:user) }
  let(:user_2) { create(:user) }
  let!(:visit) { create(:visit, user: user_1, status: 'completed') }
  let!(:another_visit) { create(:visit, user: user_2, status: 'assigned') }
  describe 'GET #index' do
    context 'when none filter is sent' do
      before do
        request.headers['Accept'] = 'application/json'
        get :index
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'result has 2 records' do
        expect(response_body.size).to eq(2)
      end
    end
    context 'when user_id filter is sent' do
      before do
        request.headers['Accept'] = 'application/json'
        get :index, params: { user_id: user_1.id }
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'result has 1 record' do
        expect(response_body.size).to eq(1)
      end
    end

    context 'when user_id and status filter are sent' do
      let!(:another_visit) { create(:visit, user: user_2, status: 'assigned') }
      let!(:pending_visit) { create(:visit, status: 'pending') }

      before do
        request.headers['Accept'] = 'application/json'
        get :index, params: { user_id: user_1.id, status: 'completed' }
      end

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'result has 1 record' do
        expect(response_body.size).to eq(1)
      end
    end

    context 'when invalid status value filter is sent' do
      let!(:another_visit) { create(:visit, user: user_2, status: 'assigned') }
      let!(:pending_visit) { create(:visit, status: 'pending') }

      before do
        request.headers['Accept'] = 'application/json'
        get :index, params: { user_id: user_1.id, status: 'invalid_status' }
      end

      it 'responds with bad_request' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  describe 'GET #show' do
    context 'when id not exists' do
      before do
        request.headers['Accept'] = 'application/json'
        get :show, params: { id: visit.id * 1000 }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when id exists' do
      before do
        request.headers['Accept'] = 'application/json'
        get :show, params: { id: visit.id }
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'result has the visit we want' do
        expect(response_body['id']).to eq(visit.id)
      end
    end
  end
end
