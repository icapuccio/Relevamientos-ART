require 'rails_helper'

describe InstitutionsController, type: :controller do
  let!(:institution) { create(:institution) }

  before do
    request.headers['Accept'] = 'application/json'
  end

  describe 'GET #show' do
    context 'When the institution id does not exist' do
      before do
        get :show, params: { id: institution.id * 1000 }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the institution id exists' do
      before do
        get :show, params: { id: institution.id }
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'returns the correct institution' do
        expect(response_body.to_json).to eq InstitutionSerializer
          .new(institution, root: false).to_json
      end
    end
  end
end
