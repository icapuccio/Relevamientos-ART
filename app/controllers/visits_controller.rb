class VisitsController < ApplicationController
  def index
    return render json: { error: 'invalid params' }, status: :bad_request unless ind_valid_params?
    @visits = Visit.includes(:institution, :user).filter(params.slice(:status, :user_id))
    respond_to do |format|
      format.json do
        render json: @visits, status: :ok
      end
      format.html
    end
  end

  def show
    visit.nil? ? show_return_not_found : show_return_ok
  end

  def assign
    return if invalid_assignment?
    visit.assign_to(user)
    if visit.save
      redirect_to visits_url, notice: 'Visita asignada'
    else
      redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def assignment_alert
    @errors = []
    validate_user
    validate_status_pending
    validate_zones
  end

  def remove_assignment
    return if invalid_remotion?
    visit.remove_assignment
    if visit.save
      redirect_to visits_url, notice: 'Visita desasignada.'
    else
      redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
    end
  end

  def complete
    return render json: { error: 'Fecha de finalización requerida' }, status: :bad_request unless
        complete_valid_params?
    visit.complete(params[:completed_at], params[:observations])
    complete_response
  end

  private

  def complete_response
    if visit.save
      render json: visit, status: :ok
    else
      render json: { error: visit.errors.full_messages.to_sentence }, status: :not_modified
    end
  end

  def validate_user
    @errors << 'Id de usuario es necesario y debe ser un preventor' unless
        params.require(:user_id) && user.role_preventor?
  end

  def validate_zones
    @errors << 'El usuario y la visita tienen diferente zona' unless
        visit.institution.zone.eql?(user.zone)
  end

  def validate_status_pending
    @errors << 'La visita no esta en estado: pendiente' unless visit.status_pending?
  end

  def invalid_assignment?
    assignment_alert
    return redirect_to visits_url, alert: @errors.join(', ') unless @errors.empty?
  end

  def visit
    visit_id = params[:id] || params[:visit_id]
    @visit ||= Visit.includes(:institution).find(visit_id)
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
  def ind_valid_params?
    params[:status].present? ? Visit.statuses.include?(params[:status]) : true
  end

  # completed_at date is mandatory
  def complete_valid_params?
    params[:completed_at].present?
  end

  def invalid_remotion?
    return redirect_to visits_url, alert: 'La visita no existe' unless visit.present?
    return redirect_to visits_url, alert: 'La visita no esta en estado: Asignada' unless
        visit.status_assigned?
  end
end
