require 'rails_helper'

describe TasksController, type: :controller do
  let!(:zone_2) { create(:zone) }
  let!(:institution_2) { create(:institution, zone: zone_2) }
  let(:user_2) { create(:user, :preventor, zone: zone_2) }
  let!(:visit) do
    create(:visit, user: user_2, to_visit_on: Time.zone.today,
                   status: 'assigned', institution: institution_2)
  end
  let!(:task_rar) { create(:task, task_type: :rar, status: :pending, visit: visit) }
  let!(:task_rgrl) { create(:task, task_type: :rgrl, status: :pending, visit: visit) }
  let!(:task_cap) { create(:task, task_type: :cap, status: :pending, visit: visit) }

  before do
    request.headers['Accept'] = 'application/json'
  end

  describe 'PUT #complete' do
    context 'When the task id does not exist' do
      before do
        put :complete, params: { task_id: task_cap.id * 1000, task: { id: task_cap.id * 1000,
                                                                      type: 3 },
                                 completed_at: 'Oct 28, 2017 12:00:00 AM',
                                 url_cloud: 'http://www.pdf995.com/samples/pdf.pdf' }
      end
      it 'responds with not found status' do
        expect(response).to have_http_status(:not_found)
      end
    end
    context 'when the task id exists' do
      context 'and the body is inconsistent' do
        before do
          put :complete, params: { task_id: task_cap.id, completed_at: 'Oct 28, 2017 12:00:00 AM',
                                   task: { id: task_cap.id, type: 3 },
                                   url_cloud: 'http://www.pdf995.com/samples/pdf.pdf' }
        end
        it 'responds with and not_modified status' do
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
      context 'and its type is CAP' do
        before do
          put :complete,
              params: {
                attendees: [
                  { cuil: '20345851306', last_name: 'Rosselló',
                    name: 'Fernando', sector: 'Sistemas' },
                  { cuil: '20345851311', last_name: 'Grula', name: 'Lucas', sector: 'IT' }
                ],
                url_cloud: 'http://www.pdf995.com/samples/pdf.pdf',
                contents: 'Seguridad e higiene', course_name: 'Curso 1',
                methodology: 'Clásica', completed_at: 'Oct 28, 2017 8:44:04 PM',
                task: { id: task_cap.id, type: task_cap.task_type.to_i },
                task_id: task_cap.id
              }
        end
        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end
        it 'returns the updated task' do
          expect(response_body.to_json).to eq TaskSerializer
            .new(task_cap.reload, root: false).to_json
        end
        it 'task is completed' do
          expect(task_cap.reload.status).to eq 'completed'
        end
        it 'visit has result' do
          expect(task_cap.reload.result).not_to eq nil
        end
        it 'result has 2 attendees' do
          expect(task_cap.reload.result.attendees.size).to eq(2)
        end
      end
      context 'and its type is RAR' do
        before do
          put :complete,
              params: {
                task_id: task_rar.id, url_cloud: 'http://www.pdf995.com/samples/pdf.pdf',
                working_men: [
                  { checked_in_on: 'Oct 28, 2017 12:00:00 AM',
                    exposed_from_at: 'Oct 28, 2017 12:00:00 AM',
                    exposed_until_at: 'Oct 28, 2017 12:00:00 AM',
                    risk_list: [
                      { code: '40001', description: 'Aceites minerales' },
                      { code: '40002', description: 'Derrumbe' }
                    ],
                    cuil: '20345851306', last_name: 'Rossello', name: 'Fernando',
                    sector: 'Sistemas' },
                  { checked_in_on: 'Oct 27, 2017 12:00:00 AM',
                    exposed_from_at: 'Oct 27, 2017 12:00:00 AM',
                    exposed_until_at: 'Oct 27, 2017 12:00:00 AM',
                    risk_list: [
                      { code: '40002', description: 'Aceites minerales' },
                      { code: '40003', description: 'Derrumbe' }
                    ],
                    cuil: '20345851372', last_name: 'Grula', name: 'Lucas', sector: 'IT' }
                ],
                completed_at: 'Oct 24, 2017 8:43:59 PM',
                task: { id: task_rar.id, task_type: task_rar.task_type.to_i }
              }
        end
        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end
        it 'returns the updated task' do
          expect(response_body.to_json).to eq TaskSerializer
            .new(task_rar.reload, root: false).to_json
        end
        it 'task is completed' do
          expect(task_rar.reload.status).to eq 'completed'
        end
        it 'visit has result' do
          expect(task_rar.reload.result).not_to eq nil
        end
        it 'result has 2 workers' do
          expect(task_rar.reload.result.workers.size).to eq(2)
        end
        it 'the worker has 2 risks' do
          expect(task_rar.reload.result.workers.first.risks.size).to eq(2)
        end
      end
      context 'and its type is RGRL' do
        before do
          put :complete,
              params: {
                task_id: task_rgrl.id,
                url_cloud: 'http://www.pdf995.com/samples/pdf.pdf',
                questions: [
                  { answer: 'Sí', category: 'Servicio de Higiente y Seguridad en el trabajo',
                    description: '¿Dispone del Servicio de Higiene y Seguridad?', id: 1 },
                  { answer: 'No Aplica',
                    category: 'Servicio de Higiente y Seguridad en el trabajo',
                    description: '¿Posee documentación actualizada con registración de todas las'\
                   ' acciones tendientes a cumplir la misión fundamental y los objetivos de '\
                   'prevención de riesgos, establecidos en la legislación vigente?', id: 2 },
                  { answer: 'No', category: 'Servicio de Medicina del trabajo',
                    description: '¿Dispone del Servicio de Medicina del trabajo?', id: 3 },
                  { answer: 'Sí', category: 'Servicio de Medicina del trabajo',
                    description: '¿Posee documentación actualizada con registración de todas '\
                  'acciones tendientes a cumplir la misión fundamental, ejecutando acciones de '\
                  'educación sanitaria,socorro, vacunación y estudios de ausentismo por morbi?',
                    id: 4 },
                  { answer: 'No Aplica', category: 'Servicio de Medicina del trabajo',
                    description: '¿Se realizan los exámenes médicos periódicos?', id: 5 }
                ], completed_at: 'Oct 28, 2017 8:44:01 PM',
                task: { id: task_rgrl.id, type: task_rgrl.task_type.to_i }
              }
        end
        it 'responds with ok' do
          expect(response).to have_http_status(:ok)
        end
        it 'returns the updated task' do
          expect(response_body.to_json).to eq TaskSerializer
            .new(task_rgrl.reload, root: false).to_json
        end
        it 'task is completed' do
          expect(task_rgrl.reload.status).to eq 'completed'
        end
        it 'visit has result' do
          expect(task_rgrl.reload.result).not_to eq nil
        end
        it 'result has 5 questions' do
          expect(task_rgrl.reload.result.questions.size).to eq(5)
        end
      end
    end
  end
end
