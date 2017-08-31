require 'rails_helper'

describe VisitsController, type: :controller do
  let(:user_1) { create(:user, :preventor) }
  let(:user_2) { create(:user, :preventor) }
  let!(:visit) do
    create(:visit, user: user_1, to_visit_on: Time.zone.today, status: 'completed')
  end
  let!(:another_visit) do
    create(:visit, user: user_2, to_visit_on: Time.zone.today, status: 'assigned')
  end
  let!(:pending_visit) { create(:visit, status: 'pending') }

  before do
    request.headers['Accept'] = 'application/json'
  end

  describe 'GET #index' do
    context 'when no filters are sent' do
      before do
        get :index
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns all the visits' do
        expect(response_body.size).to eq(3)
      end
    end
    context 'when user_id filter is sent' do
      before do
        get :index, params: { user_id: user_1.id }
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns 1 record' do
        expect(response_body.size).to eq(1)
      end
    end

    context 'when user_id and status filter are sent' do
      before do
        get :index, params: { user_id: user_1.id, status: 'completed' }
      end

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns 1 record' do
        expect(response_body.size).to eq(1)
      end
    end

    context 'When the user_id does not exist' do
      before do
        get :index, params: { user_id: 111 }
      end

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns an empty list' do
        expect(response_body.size).to eq(0)
      end
    end

    context 'When the user_id comes nil' do
      before do
        get :index, params: { user_id: nil }
      end

      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end

      it 'returns all the visits' do
        expect(response_body.size).to eq(3)
      end
    end

    context 'when invalid status value filter is sent' do
      before do
        get :index, params: { user_id: user_1.id, status: 'invalid_status' }
      end

      it 'responds with bad_request' do
        expect(response).to have_http_status(:bad_request)
      end
    end
  end
  describe 'GET #show' do
    context 'When the visit id does not exist' do
      before do
        get :show, params: { id: visit.id * 1000 }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the visit id exists' do
      before do
        get :show, params: { id: visit.id }
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns the correct visit' do
        expect(response_body.to_json).to eq VisitSerializer
          .new(visit, root: false).to_json
      end
    end
  end
end
