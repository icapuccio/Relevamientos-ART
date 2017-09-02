class VisitsController < ApplicationController
  def index
    return render json: { error: 'Invalid params' }, status: :bad_request unless valid_params?
    @visits = Visit.includes(:institution).filter(params.slice(:status, :user_id))
    respond_to do |format|
      format.json do
        render json: @visits, status: :ok
      end
      format.html
    end
  end

  def show
    respond_to do |format|
      visit.nil? ? return_not_found(format) : return_ok(format)
    end
  end

  def visit
    @visit ||= Visit.includes(:institution).find(params[:id])
  end

  def return_not_found(format)
    format.json do
      render json: visit, status: :not_found
    end
    format.html { redirect_to @visits, notice: 'Visit not found' }
  end

  def return_ok(format)
    format.json do
      render json: visit, status: :ok
    end
    format.html
  end

  # status param is optional
  # user_id param is optional
  def valid_params?
    params[:status].present? ? Visit.statuses.include?(params[:status]) : true
  end
end
