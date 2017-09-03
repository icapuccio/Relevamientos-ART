class VisitsController < ApplicationController
  def index
    return render json: { error: 'Invalid params' }, status: :bad_request unless ind_valid_params?
    @visits = Visit.includes(:institution).filter(params.slice(:status, :user_id))
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

  def assignment
    return if assignment_validations
    visit.assign_to(user)
    return redirect_to visits_url, notice: 'Visita asignada' if visit.save
    redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
  end

  def assignment_validations
    assignment_alert
    return redirect_to visits_url, alert: @alert if @alert.present?
  end

  def assignment_alert
    @alert = 'User_id is required and must be a preventos' unless
        params.require(:user_id) && user.role_preventor?
    @alert = 'Visit not in status pending' unless visit.status_pending?
    @alert = 'User and Visit have different zones' unless visit.institution.zone.eql?(user.zone)
  end

  def invalid_html_error(format, msg)
    format.html { redirect_to visits_url, alert: msg }
  end

  def revert_assignment
    return if revert_assignment_valid_params?
    visit.revert_assignment
    return redirect_to visits_url, notice: 'Visita desasignada.' if visit.save
    redirect_to visits_url, alert: visit.errors.full_messages.to_sentence
  end

  def visit
    @visit ||= Visit.includes(:institution).find(params[:id])
  end

  def user
    @user ||= User.find(params[:user_id])
    # como salvo la excepcion cuando el user que me pasan no esta?
  end

  def show_return_not_found
    respond_to do |format|
      format.json do
        render json: visit, status: :not_found
      end
      format.html { redirect_to visits_url, notice: 'Visit not founded' }
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

  # status param is optional
  # user_id param is optional
  def ind_valid_params?
    params[:status].present? ? Visit.statuses.include?(params[:status]) : true
  end

  def revert_assignment_valid_params?
    return redirect_to visits_url, alert: 'Visit not exists' unless visit.present?
    return redirect_to visits_url, alert: 'Visit not in status assigned' unless
        visit.status_assigned?
  end
end
