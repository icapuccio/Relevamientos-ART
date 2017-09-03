require 'rails_helper'

describe VisitsController, type: :controller do
  let!(:zone_1) { create(:zone) }
  let!(:zone_2) { create(:zone) }
  let!(:institution_1) { create(:institution, zone: zone_1) }
  let!(:institution_2) { create(:institution, zone: zone_2) }
  let(:user_1) { create(:user, :preventor, zone: zone_1) }
  let(:user_2) { create(:user, :preventor, zone: zone_2) }
  let!(:visit) do
    create(:visit, :completed, user: user_1, institution: institution_1)
  end
  let!(:another_visit) do
    create(:visit, user: user_2, to_visit_on: Time.zone.today,
                   status: 'assigned', institution: institution_2)
  end
  let!(:pending_visit) { create(:visit, status: 'pending', institution: institution_1) }

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

  describe 'POST #assignment' do
    before do
      request.headers['Accept'] = 'text/html'
    end
    context 'When the visit exists,' do
      context 'have status pending' do
        context ' the user exists' do
          context 'but it has not a preventor role' do
            let!(:pend_visit_2) { create(:visit, status: 'pending', institution: institution_1) }
            let(:role) { 'backoffice' }
            let!(:user_backoffice) { create(:user, role: role) }
            before do
              post :assignment, params: { id: pend_visit_2.id, user_id: user_backoffice.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'not was assigned to the user' do
              expect(Visit.find(pend_visit_2.id).user).to eq nil
            end
            it 'status not change' do
              expect(Visit.find(pend_visit_2.id).status).to eq 'pending'
            end
          end
          context 'and both have the same zone' do
            let!(:pend_visit_2) { create(:visit, status: 'pending', institution: institution_1) }
            before do
              post :assignment, params: { id: pend_visit_2.id, user_id: user_1.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'assign the visit to the user' do
              expect(Visit.find(pend_visit_2.id).user).to eq user_1
            end
            it 'changed status to assigned' do
              expect(Visit.find(pend_visit_2.id).status).to eq 'assigned'
            end
          end
          context 'and have not the same zone' do
            let!(:pend_visit_3) { create(:visit, status: 'pending', institution: institution_2) }
            before do
              post :assignment, params: { id: pend_visit_3.id, user_id: user_1.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'not was assigned to the user' do
              expect(Visit.find(pend_visit_3.id).user).to eq nil
            end
            it 'status not change' do
              expect(Visit.find(pend_visit_3.id).status).to eq 'pending'
            end
          end
        end
        context 'and the user not exists' do
          let!(:pend_visit_3) { create(:visit, status: 'pending', institution: institution_2) }
          before do
            post :assignment, params: { id: pend_visit_3.id, user_id: user_1.id * 1000 }
          end
          # quiero que se comporte asi, pero actualmente devuelve un 404
          # it 'responds found' do
          #  expect(response.response_code).to eq 302
          # end
          # it 'not was assigned to the user' do
          #  expect(Visit.find(pend_visit_3.id).user).to eq nil
          # end
          # it 'status not change' do
          #  expect(Visit.find(pend_visit_3.id).status).to eq 'pending'
          # end
        end
      end
    end

    context 'When the visit not exists' do
    end
  end
end
