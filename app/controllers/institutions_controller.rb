class InstitutionsController < ApplicationController
  def show
    respond_to do |format|
      institution.nil? ? return_not_found(format) : return_ok(format)
    end
  end

  def institution
    @institution ||= Institution.includes(:zone).find(params[:id])
  end

  def return_not_found(format)
    format.json do
      render json: institution, status: :not_found
    end
    format.html { redirect_to @visits, notice: 'Institution not found' }
  end

  def return_ok(format)
    format.json do
      render json: institution, status: :ok
    end
    format.html
  end
end
