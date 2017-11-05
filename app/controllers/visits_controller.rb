class VisitsController < ApplicationController
  def index
    return render json: { error: 'invalid params' }, status: :bad_request unless
      index_valid_params?
    @visits = Visit.includes(:institution, :user).filter(params.slice(:status, :user_id))
    respond_to do |format|
      format.json do
        render json: @visits, status: :ok
      end
      format.html
    end
  end

  def completed_report_index
    @visits = Visit.includes(:institution, :user).completed
  end

  def show
    visit.nil? ? show_return_not_found : show_return_ok
  end

  def assign
    return redirect_to visits_url, alert: 'Se debe enviar user_id' unless user_present?
    if visit.assign_to(user)
      redirect_to visits_url, notice: 'Visita asignada'
    else
      redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def remove_assignment
    return if invalid_remotion?
    if visit.remove_assignment
      redirect_to visits_url, notice: 'Visita desasignada.'
    else
      redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def complete
    return render json: { error: 'Fecha de finalización requerida' }, status: :bad_request unless
      complete_date_present?
    complete_response
  end

  def completed_report
    @visits = Visit.completed
    @message = 'No existen nuevas visitas para enviar a la Superintencia de Riesgo de Trabajo.'
    return redirect_to completed_report_visits_url, alert: @message unless @visits.present?
    ActiveRecord::Base.transaction { @visits.each(&:status_sent) }
    @message = 'Las visitas fueron enviadas a la Superintencia de Riesgo de Trabajo exitosamente.'
    return redirect_to completed_report_visits_url, notice: @message
  rescue ActiveRecord::RecordInvalid => exception
    return redirect_to completed_report_visits_url, alert: exception.message
  end

  private

  def complete_response
    if visit.complete(params)
      render json: visit, status: :ok
    else
      render json: { error: visit.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def user_present?
    params[:user_id].present?
  end

  def visit
    visit_id = params[:id] || params[:visit_id]
    @visit ||= Visit.includes(:institution, :tasks).find(visit_id)
  end

  def user
    @user ||= User.find(params[:user_id])
  end

  def show_return_not_found
    respond_to do |format|
      format.json do
        render render_nothing_not_found
      end
      format.html do
        flash[:alert] = 'Visita no encontrada'
        redirect_to visits_url
      end
    end
  end

  def show_return_ok
    respond_to do |format|
      format.json do
        render json: visit, status: :ok
      end
      format.html
    end
  end

  # status and user_id param is optional
  def index_valid_params?
    params[:status].present? ? Visit.statuses.include?(params[:status]) : true
  end

  # completed_at date is mandatory
  def complete_date_present?
    params[:completed_at].present?
  end

  def invalid_remotion?
    return redirect_to visits_url, alert: 'La visita no existe' unless visit.present?
    return redirect_to visits_url, alert: 'La visita no esta en estado: Asignada' unless
        visit.status_assigned?
  end
end
