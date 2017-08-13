class SessionsController < Devise::SessionsController
  # http_basic_authenticate_with name: "admin", password: "secret"

  def create
    respond_to do |format|
      format.html { super }
      format.json do
        if authenticated_user?
          render json: { id: user.id, email: user.email }, status: :ok
        else
          render json: { error: 'invalid-credentials' }, status: :unauthorized
        end
      end
    end
  end

  private

  def authenticated_user?
    user.present? && user.valid_password?(session_params[:password])
  end

  def user
    @user ||= User.find_by(email: session_params[:email])
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
