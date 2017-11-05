require 'rails_helper'

describe VisitsController, type: :controller do
  let!(:zone_1) { create(:zone) }
  let!(:zone_2) { create(:zone) }
  let!(:institution_1) { create(:institution, zone: zone_1) }
  let!(:institution_2) { create(:institution, zone: zone_2) }
  let(:user_1) { create(:user, :preventor, zone: zone_1) }
  let(:user_2) { create(:user, :preventor, zone: zone_2) }
  let!(:assigned_visit) do
    create(:visit, user: user_2, to_visit_on: Time.zone.today,
                   status: 'assigned', institution: institution_2)
  end
  let!(:pending_visit) { create(:visit, status: 'pending', institution: institution_1) }

  before do
    request.headers['Accept'] = 'application/json'
  end

  describe 'GET #index' do
    let!(:visit) do
      create(:visit, :completed, user: user_1, institution: institution_1)
    end
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
    let!(:visit) do
      create(:visit, :completed, user: user_1, institution: institution_1)
    end
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
      request.headers['Content-Type'] = 'text/html'
    end
    context 'When the visit exists,' do
      context 'have status pending' do
        context ' the user exists' do
          context 'but it has not a preventor role' do
            let!(:pend_visit_2) { create(:visit, status: 'pending', institution: institution_1) }
            let(:role) { 'backoffice' }
            let!(:user_backoffice) { create(:user, role: role) }
            before do
              post :assign, params: { visit_id: pend_visit_2.id, user_id: user_backoffice.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'not was assigned to the user' do
              expect(pend_visit_2.reload.user).to eq nil
            end
            it 'status not change' do
              expect(pend_visit_2.reload.status).to eq 'pending'
            end
          end
          context 'and both have the same zone' do
            let!(:pend_visit_2) { create(:visit, status: 'pending', institution: institution_1) }
            before do
              post :assign, params: { visit_id: pend_visit_2.id, user_id: user_1.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'assign the visit to the user' do
              expect(pend_visit_2.reload.user).to eq user_1
            end
            it 'changed status to assigned' do
              expect(pend_visit_2.reload.status).to eq 'assigned'
            end
          end
          context 'and have not the same zone' do
            let!(:pend_visit_3) { create(:visit, status: 'pending', institution: institution_2) }
            before do
              post :assign, params: { id: pend_visit_3.id, visit_id: pend_visit_3.id,
                                      user_id: user_1.id }
            end
            it 'responds found' do
              expect(response.response_code).to eq 302
            end
            it 'not was assigned to the user' do
              expect(pend_visit_3.reload.user).to eq nil
            end
            it 'status not change' do
              expect(pend_visit_3.reload.status).to eq 'pending'
            end
          end
        end
        context 'and the user not exists' do
          let!(:pend_visit_3) { create(:visit, status: 'pending', institution: institution_2) }
          before do
            post :assign, params: { visit_id: pend_visit_3.id, user_id: user_1.id * 1000 }
          end
          it 'responds found' do
            expect(response.response_code).to eq 404
          end
          it 'not was assigned to the user' do
            expect(pend_visit_3.reload.user).to eq nil
          end
          it 'status not change' do
            expect(pend_visit_3.reload.status).to eq 'pending'
          end
        end
      end
      context 'have not status pending and different zones' do
        before do
          post :assign, params: { visit_id: assigned_visit.id, user_id: user_1.id }
        end
        it 'responds found' do
          expect(response.response_code).to eq 302
        end
        it 'responds with an alarm' do
          expect(response.flash.alert).to eq 'La visita debe estar en estado pendiente '\
          'and EL usuario y la visita deben tener la misma zona'
        end
      end
    end
  end
  describe 'PUT #remove_assignment' do
    before do
      request.headers['Content-Type'] = 'text/html'
    end
    context 'When the visit exists' do
      context 'and have status assigned' do
        before do
          post :remove_assignment, params: { visit_id: assigned_visit.id }
        end
        it 'responds found' do
          expect(response.response_code).to eq 302
        end
        it 'not was assigned to the user' do
          expect(assigned_visit.reload.user).to eq nil
        end
        it 'status not change' do
          expect(assigned_visit.reload.status).to eq 'pending'
        end
      end
      context 'and have not status assigned' do
        before do
          post :remove_assignment, params: { visit_id: pending_visit.id }
        end
        it 'responds found' do
          expect(response.response_code).to eq 302
        end
        it 'responds with an alarm' do
          expect(response.flash.alert).to eq 'La visita no esta en estado: Asignada'
        end
      end
    end
  end
  describe 'PUT #complete' do
    context 'When the visit id does not exist' do
      let!(:completed_at) { DateTime.current }
      before do
        put :complete, params: { visit_id: assigned_visit.id * 1000, completed_at: completed_at }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the visit id exists' do
      let!(:completed_at) { DateTime.current }
      context 'and has pending tasks' do
        let!(:task) { create(:task, visit: assigned_visit, status: 'pending') }
        before do
          put :complete, params: { visit_id: assigned_visit.id, completed_at: completed_at }
        end
        it 'responds with and not_modified status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      context 'and has all the tasks completed' do
        let!(:task) do
          create(:task, visit: assigned_visit, task_type: :rgrl, status: 'pending')
        end
        let!(:rgrl_result) { create(:rgrl_result, task: task) }
        let!(:question) do
          create(:question, description: 'Quien soy', answer: 'El Junior de la muelte',
                            category: 'Maniiiel', rgrl_result: rgrl_result)
        end
        let!(:obs) { 'todo OK' }
        before do
          task.complete(completed_at)
          put :complete, params: { visit_id: assigned_visit.id, completed_at: completed_at,
                                   observations: obs }
        end
        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end
        it 'returns the updated visit' do
          expect(response_body.to_json).to eq VisitSerializer
            .new(assigned_visit.reload, root: false).to_json
        end
        it 'visit is completed' do
          expect(assigned_visit.reload.status).to eq 'completed'
        end
        it 'visit has obs' do
          expect(assigned_visit.reload.observations).to eq obs
        end
      end
    end
  end
  describe 'POST #completed_report' do
    let!(:pend_visit_2) { create(:visit, status: 'pending', institution: institution_1) }
    before do
      request.headers['Content-Type'] = 'text/html'
    end
    context 'when there are no completed visits' do
      before do
        post :completed_report
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a notice' do
        expect(response.flash.alert).to eq 'No existen nuevas visitas para enviar '\
          'a la Superintencia de Riesgo de Trabajo.'
      end
    end
    context 'when there are completed visits' do
      let!(:completed_visit) do
        create(:visit, :completed, to_visit_on: Time.zone.today, completed_at: Time.zone.today,
                                   user: user_1, institution: institution_1)
      end
      let!(:task_rgrl) do
        create(:task, task_type: 'rgrl', status: 'pending', visit: completed_visit)
      end

      before do
        post :completed_report
      end
      it 'responds found' do
        task_rgrl.create_result(completed_at: Time.zone.today.to_s,
                                questions: [
                                  { description: 'quien sos?', answer: 'el virrey',
                                    category: 'personales' }
                                ])
        expect(response.response_code).to eq 302
      end
      it 'responds with a notice' do
        expect(response.flash.notice).to eq 'Las visitas fueron enviadas a la '\
          'Superintencia de Riesgo de Trabajo exitosamente.'
      end
      it 'the completed visits change status to sent' do
        expect(completed_visit.reload.status).to eq 'sent'
      end
    end
  end
end
