class VisitsController < ApplicationController
  def index
    return render json: { error: 'invalid params' }, status: :bad_request unless
      index_valid_params?
    @visits = Visit.includes(:institution, :user)
                   .filter(params.slice(:status, :user_id))
                   .order(status: :asc, priority: :asc)
    respond_to do |format|
      format.json { render json: @visits, status: :ok }
      format.html
    end
  end

  def assignment_index
    @visits = Visit.includes(:institution, :user)
                   .assignable.order(status: :asc, priority: :asc, id: :asc)
  end

  def show
    visit.nil? ? show_return_not_found : show_return_ok
  end

  def edit
    unless available_preventor_for_visit?
      return redirect_to assignment_url,
                         alert: 'No existe preventor disponible para asignar a esta visita'
    end
    visit
  end

  def update
    assign
  end

  def assign
    return redirect_to assignment_url, alert: 'Se debe asignar un preventor' unless user.present?
    process_assignment
  end

  def remove_assignment
    return if invalid_remotion?
    if visit.remove_assignment
      redirect_to assignment_index_visits_url, notice: 'Visita desasignada.'
    else
      redirect_to assignment_index_visits_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def complete
    return render json: { error: 'Fecha de finalización requerida' }, status: :bad_request unless
        complete_date_present?
    complete_response
  end

  private

  def complete_response
    if visit.complete(params[:completed_at], params[:observations])
      render json: visit, status: :ok
    else
      render json: { error: visit.errors.full_messages.to_sentence }, status: :unprocessable_entity
    end
  end

  def visit
    visit_id = params[:id] || params[:visit_id]
    @visit ||= Visit.includes(:institution).find(visit_id)
  end

  def user
    user_id = params[:user_id] || params[:visit][:user]
    @user ||= User.find(user_id)
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

  def assignment_url
    assignment_index_visits_url
  end

  def process_assignment
    if visit.assign_to(user)
      redirect_to assignment_url, notice: 'Visita asignada'
    else
      redirect_to assignment_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def available_preventor_for_visit?
    User.includes(:zone).assignable_for_visit(visit).present?
  end
end
