class VisitsController < ApplicationController
  def index
    return render json: { error: 'Invalid params' }, status: :bad_request unless valid_params?
    @visits = Visit.filter(params.slice(:status, :user_id))
    respond_to do |format|
      format.json do
        render json: @visits, status: :ok
      end
      format.html
    end
  end

  def show
    @visit = Visit.find(params[:id])
    respond_to do |format|
      if @visit.nil?
        show_not_found_format(format)
      else
        show_format_ok(format)
      end
    end
  end

  def show_not_found_format(format)
    format.json do
      render json: @visit, status: :not_found
    end
    format.html { redirect_to @visits, notice: 'Visit not found' }
  end

  def show_format_ok(format)
    format.json do
      render json: @visit, status: :ok
    end
    format.html
  end

  # status param is optional
  # user_id param is optional
  def valid_params?
    params[:status].present? ? Visit.statuses.include?(params[:status]) : true
  end
end
