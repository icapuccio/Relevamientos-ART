class VisitsController < ApplicationController
  def index
    return render json: { error: 'Invalid params' }, status: :bad_request unless valid_params?
    @visits = Visit.filter(params.slice(:status, :user_id))
    respond_to do |format|
      format.json do
        render json: @visits, status: :ok
      end
      format.html
      format.xml
    end
  end

  # status param is optional
  # user_id param is optional
  def valid_params?
    (visit_params && (params[:status].present? ? Visit.statuses.include?(params[:status]) : true))
  end

  def visit_params
    params.permit(:user_id, :status)
  end
end