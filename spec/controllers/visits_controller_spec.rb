require 'rails_helper'
require 'webmock/rspec'

describe VisitsController, type: :controller do
  let!(:zone_1) { create(:zone) }
  let!(:zone_2) { create(:zone) }
  let!(:zone_3) { create(:zone) }
  let!(:zone_4) { create(:zone) }
  let!(:institution_1) { create(:institution, zone: zone_1) }
  let!(:institution_2) { create(:institution, zone: zone_2) }
  let!(:institution_3) { create(:institution, zone: zone_3) }
  let!(:institution_4) { create(:institution, zone: zone_4) }
  let!(:institution_11) { create(:institution, zone: zone_1) }
  let!(:institution_12) { create(:institution, zone: zone_1) }
  let!(:institution_13) { create(:institution, zone: zone_1) }
  let!(:institution_14) { create(:institution, zone: zone_1) }
  let!(:institution_15) { create(:institution, zone: zone_1) }
  let!(:institution_21) { create(:institution, zone: zone_2) }
  let!(:institution_22) { create(:institution, zone: zone_2) }
  let!(:institution_23) { create(:institution, zone: zone_2) }
  let!(:institution_24) { create(:institution, zone: zone_2) }
  let!(:institution_31) { create(:institution, zone: zone_3) }
  let!(:institution_32) { create(:institution, zone: zone_3) }
  let!(:institution_33) { create(:institution, zone: zone_3) }
  let!(:institution_34) { create(:institution, zone: zone_3) }
  let!(:institution_41) { create(:institution, zone: zone_4) }
  let!(:institution_42) { create(:institution, zone: zone_4) }
  let(:user_1) { create(:user, :preventor, zone: zone_1) }
  let(:user_11) { create(:user, :preventor, zone: zone_1) }
  let(:user_12) { create(:user, :preventor, zone: zone_1) }
  let(:user_2) { create(:user, :preventor, zone: zone_2) }
  let(:user_21) { create(:user, :preventor, zone: zone_2) }
  let(:user_22) { create(:user, :preventor, zone: zone_2) }
  let(:user_3) { create(:user, :preventor, zone: zone_3) }
  let(:user_4) { create(:user, :preventor, zone: zone_4) }
  let!(:assigned_visit) do
    create(:visit, user: user_2, to_visit_on: Time.zone.today,
                   status: 'assigned', institution: institution_2)
  end
  let!(:p_visit) { create(:visit, status: 'pending', priority: 0, institution: institution_1) }
  let!(:p_visit_11) { create(:visit, status: 'pending', priority: 1, institution: institution_11) }
  let!(:p_visit_12) { create(:visit, status: 'pending', priority: 2, institution: institution_12) }
  let!(:p_visit_13) { create(:visit, status: 'pending', priority: 3, institution: institution_13) }
  let!(:p_visit_14) { create(:visit, status: 'pending', priority: 4, institution: institution_14) }
  let!(:p_visit_15) { create(:visit, status: 'pending', priority: 5, institution: institution_15) }
  let!(:p_visit_21) { create(:visit, status: 'pending', institution: institution_21) }
  let!(:p_visit_22) { create(:visit, status: 'pending', institution: institution_22) }
  let!(:p_visit_23) { create(:visit, status: 'pending', institution: institution_23) }
  let!(:p_visit_24) { create(:visit, status: 'pending', institution: institution_24) }
  let!(:p_visit_31) { create(:visit, status: 'pending', institution: institution_31) }
  let!(:p_visit_32) { create(:visit, status: 'pending', institution: institution_32) }
  let!(:p_visit_33) { create(:visit, status: 'pending', institution: institution_33) }
  let!(:p_visit_34) { create(:visit, status: 'pending', institution: institution_34) }
  let!(:p_visit_41) { create(:visit, status: 'pending', institution: institution_41) }
  let!(:p_visit_42) { create(:visit, status: 'pending', institution: institution_42) }

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
        expect(response_body.size).to eq(18)
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
        expect(response_body.size).to eq(18)
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
          post :remove_assignment, params: { visit_id: p_visit.id }
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
      let!(:completed_at) { DateTime.current.to_s }
      before do
        put :complete, params: { visit_id: assigned_visit.id * 1000, completed_at: completed_at }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the visit id exists' do
      let!(:completed_at) { DateTime.current.to_s }
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
        context 'and has not images and noises' do
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
          it 'visit has not images' do
            expect(assigned_visit.reload.visit_images.size).to eq(0)
          end
          it 'visit has not noises' do
            expect(assigned_visit.reload.visit_noises.size).to eq(0)
          end
        end
        context 'and has images and noises' do
          before do
            task.complete(completed_at)
            put :complete,
                params: {
                  visit_id: assigned_visit.id,
                  completed_at: completed_at,
                  observations: obs,
                  noises: [
                    { description: 'muestra 1', decibels: 16.123456 },
                    { description: 'muestra 2', decibels: 16.2345 }
                  ],
                  images: [
                    { url_cloud: 'http:lalala.com/1234' },
                    { url_cloud: 'http:lalala.com/1235' }
                  ]
                }
          end
          it 'responds with ok' do
            expect(response).to have_http_status(:ok)
          end
          it 'returns the updated visit' do
            expect(response_body.to_json).to eq VisitSerializer.new(
              assigned_visit.reload, root: false
            ).to_json
          end
          it 'visit is completed' do
            expect(assigned_visit.reload.status).to eq 'completed'
          end
          it 'visit has obs' do
            expect(assigned_visit.reload.observations).to eq obs
          end
          it 'visit has images' do
            expect(assigned_visit.reload.visit_images.size).to eq(2)
          end
          it 'visit has noises' do
            expect(assigned_visit.reload.visit_noises.size).to eq(2)
          end
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
          'a la Superintendencia de Riesgo de Trabajo.'
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
                                url_cloud: 'blablabla.pdf',
                                questions: [
                                  { description: 'quien sos?', answer: 'el virrey',
                                    category: 'personales' }
                                ])
        expect(response.response_code).to eq 302
      end
      it 'responds with a notice' do
        expect(response.flash.notice).to eq 'Las visitas fueron enviadas a la '\
          'Superintendencia de Riesgo de Trabajo exitosamente.'
      end
      it 'the completed visits change status to sent' do
        expect(completed_visit.reload.status).to eq 'sent'
      end
    end
  end
  describe 'POST #syncro_visits' do
    context 'the SRT GET returns a valid visit to create' do
      before do
        body = [{ 'priority': 1, 'institution_id': institution_1.id,
                  'tasks': [{ 'type': 'rar' }, { 'type': 'rgrl' }], 'external_id': 100 }]
        stub_request(:get, 'https://private-13dd3-relevamientosart.apiary-mock.com/visits')
          .to_return('headers': { 'Content-Type': 'application/json' }, 'body': body.to_json)
        request.headers['Content-Type'] = 'text/html'
        post :syncro_visits
      end
      it 'responds with a notice' do
        expect(response.flash.notice).to eq 'Se crearon exitosamente 1 visitas a realizar.'
      end
      it 'The Visit with that external_id was created' do
        expect(Visit.where(external_id: 100)).not_to eq nil
      end
    end
    context 'the SRT GET returns an invalid visit to create' do
      before do
        body = [{ 'priority': 2, 'institution_id': institution_1.id,
                  'tasks': [{ 'type': 'rar' }, { 'type': 'asdfasdf' }], 'external_id': 101 }]
        stub_request(:get, 'https://private-13dd3-relevamientosart.apiary-mock.com/visits')
          .to_return('headers': { 'Content-Type': 'application/json' }, 'body': body.to_json)
        request.headers['Content-Type'] = 'text/html'
        post :syncro_visits
      end
      it 'responds with an alert' do
        expect(response.flash.alert).to eq 'Todas las visitas (1) contienen errores.'
      end
      it 'The invalid visit was not created' do
        expect(!Visit.where(external_id: 101).present?)
      end
    end
    context 'the SRT GET returns a valid an invalid visit to create' do
      before do
        body = [
          { 'priority': 2, 'institution_id': institution_1.id,
            'tasks': [{ 'type': 'rar' }, { 'type': 'asdfasdf' }], 'external_id': 101 },
          { 'priority': 10, 'institution_id': institution_1.id,
            'tasks': [{ 'type': 'rar' }], 'external_id': 201 }
        ]
        stub_request(:get, 'https://private-13dd3-relevamientosart.apiary-mock.com/visits')
          .to_return('headers': { 'Content-Type': 'application/json' }, 'body': body.to_json)
        request.headers['Content-Type'] = 'text/html'
        post :syncro_visits
      end
      it 'responds with an alert' do
        expect(response.flash.alert).to eq 'Se crearon exitosamente 1 visitas a realizar.'\
          ' Existen 1 con inconsistencias.'
      end
      it 'The invalid visit was not created' do
        expect(!Visit.where(external_id: 101).present?)
      end
      it 'The valid visit was created' do
        expect(!Visit.where(external_id: 201).present?)
      end
    end
  end
  describe 'POST #auto_assignments' do
    before do
      request.headers['Content-Type'] = 'text/html'
    end
    context 'when the user did not select visits to assign' do
      before do
        post :auto_assignments, params: { visits: [], users: [user_1.id] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.alert).to eq 'Se debe seleccionar al menos una visita'\
        ' y un preventor'
      end
    end
    context 'when the user did not select users to assign' do
      before do
        post :auto_assignments, params: { visits: [p_visit.id], users: [] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.alert).to eq 'Se debe seleccionar al menos una visita'\
        ' y un preventor'
      end
    end
    context 'the user selects 2 tasks for one zone and 1 user for a different zone' do
      before do
        post :auto_assignments, params: { visits: [p_visit_31.id, p_visit_21.id],
                                          users: [user_4.id, user_1.id] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.alert).to eq 'No se pudo asignar ninguna visita '\
      'de forma automática. Intente realizar la asignación de forma manual.'
      end
      it 'the visits did not change status ' do
        expect(p_visit_31.reload.status).to eq 'pending'
        expect(p_visit_21.reload.status).to eq 'pending'
      end
    end
    context 'the user selects 6 tasks for the same zone and 1 user for that zone' do
      before do
        post :auto_assignments, params: { visits: [p_visit.id, p_visit_11.id,
                                                   p_visit_12.id, p_visit_13.id,
                                                   p_visit_14.id, p_visit_15.id],
                                          users: [user_3.id, user_1.id] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.alert).to eq 'Se asignaron exitosamente 5 visitas. '\
      '1 visitas no pudieron ser asignadas.'
      end
      it 'the visit whit less priority did not change ' do
        expect(p_visit_15.reload.status).to eq 'pending'
      end
      it 'the 5 visits whit more priority were assigned' do
        expect(p_visit.reload.status).to eq 'assigned'
        expect(p_visit_11.reload.status).to eq 'assigned'
        expect(p_visit_12.reload.status).to eq 'assigned'
        expect(p_visit_13.reload.status).to eq 'assigned'
        expect(p_visit_14.reload.status).to eq 'assigned'
      end
    end
    context 'the user selects 6 tasks for the same zone and 3 users for that zone' do
      before do
        post :auto_assignments, params: { visits: [p_visit.id, p_visit_11.id,
                                                   p_visit_12.id, p_visit_13.id,
                                                   p_visit_14.id, p_visit_15.id],
                                          users: [user_12.id, user_1.id, user_11.id, user_3.id] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.notice).to eq 'Se asignaron exitosamente 6 visitas.'
      end
      it 'the 6 visits  were assigned' do
        expect(p_visit.reload.status).to eq 'assigned'
        expect(p_visit_11.reload.status).to eq 'assigned'
        expect(p_visit_12.reload.status).to eq 'assigned'
        expect(p_visit_13.reload.status).to eq 'assigned'
        expect(p_visit_14.reload.status).to eq 'assigned'
        expect(p_visit_15.reload.status).to eq 'assigned'
      end
      it 'each user has 2 tasks assigned' do
        expect(user_12.visits.size).to eq(2)
        expect(user_1.visits.size).to eq(2)
        expect(user_11.visits.size).to eq(2)
      end
    end
    context 'the user selects 16 tasks and 5 users' do
      before do
        post :auto_assignments, params: { visits: [p_visit.id, p_visit_11.id,
                                                   p_visit_12.id, p_visit_13.id,
                                                   p_visit_14.id, p_visit_15.id,
                                                   p_visit.id, p_visit_11.id,
                                                   p_visit_21.id, p_visit_22.id,
                                                   p_visit_23.id, p_visit_24.id,
                                                   p_visit_31.id, p_visit_32.id,
                                                   p_visit_33.id, p_visit_34.id,
                                                   p_visit_41.id, p_visit_42.id],
                                          users: [user_12.id, user_11.id, user_3.id, user_21.id,
                                                  user_22.id] }
      end
      it 'responds found' do
        expect(response.response_code).to eq 302
      end
      it 'responds with a alert' do
        expect(response.flash.alert).to eq 'Se asignaron exitosamente 14 visitas. '\
      '2 visitas no pudieron ser asignadas.'
      end
      it 'the 6 visits  were assigned' do
        expect(p_visit.reload.status).to eq 'assigned'
        expect(p_visit_11.reload.status).to eq 'assigned'
        expect(p_visit_12.reload.status).to eq 'assigned'
        expect(p_visit_13.reload.status).to eq 'assigned'
        expect(p_visit_14.reload.status).to eq 'assigned'
        expect(p_visit_15.reload.status).to eq 'assigned'
        expect(p_visit_21.reload.status).to eq 'assigned'
        expect(p_visit_22.reload.status).to eq 'assigned'
        expect(p_visit_23.reload.status).to eq 'assigned'
        expect(p_visit_24.reload.status).to eq 'assigned'
        expect(p_visit_31.reload.status).to eq 'assigned'
        expect(p_visit_32.reload.status).to eq 'assigned'
        expect(p_visit_33.reload.status).to eq 'assigned'
        expect(p_visit_34.reload.status).to eq 'assigned'
        expect(p_visit_41.reload.status).to eq 'pending'
        expect(p_visit_42.reload.status).to eq 'pending'
      end
      it 'each user has X tasks assigned' do
        expect(user_12.visits.size).to eq(3)
        expect(user_11.visits.size).to eq(3)
        expect(user_21.visits.size).to eq(2)
        expect(user_22.visits.size).to eq(2)
        expect(user_3.visits.size).to eq(4)
        expect(user_4.visits.size).to eq(0)
      end
    end
  end

  describe 'PUT #in_process' do
    before { put :in_process, params: { visit_id: visit.id } }

    context 'when the visit is pending' do
      let!(:visit) { create(:visit) }

      it 'does not update the visit' do
        expect(visit.reload.status).to eq 'pending'
      end
      it 'responds with unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns the error message' do
        expect(response_body['error']).to eq 'No se puede actualizar la visita'
      end
    end

    context 'when the visit is assigned' do
      let!(:visit) { create(:visit, :with_user, status: :assigned) }

      it 'updates the visit to in process status' do
        expect(visit.reload.status).to eq 'in_process'
      end
      it 'responds with ok' do
        expect(response).to have_http_status(:ok)
      end
      it 'does not return a body' do
        expect(response.body).to be_empty
      end
    end

    context 'when the visit is in process' do
      let!(:visit) { create(:visit, :with_user, status: :in_process) }

      it 'does not update the visit' do
        expect(visit.reload.status).to eq 'in_process'
      end
      it 'responds with unprocessable entity' do
        expect(response).to have_http_status(:unprocessable_entity)
      end
      it 'returns the error message' do
        expect(response_body['error']).to eq 'No se puede actualizar la visita'
      end
    end
  end
end
