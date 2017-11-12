class SessionsController < Devise::SessionsController
  # http_basic_authenticate_with name: "admin", password: "secret"

  # rubocop:disable Metrics/MethodLength
  def create
    respond_to do |format|
      format.html do
        if authenticated_user_preventor?
          return redirect_to login_url, alert: 'El rol asociado a su usuario no tiene permisos' \
            ' para acceder'
        end
        super
      end
      format.json do
        if authenticated_user?
          render json: { id: user.id, email: user.email }, status: :ok
        else
          render json: { error: 'invalid-credentials' }, status: :unauthorized
        end
      end
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def authenticated_user?
    user.present? && user.valid_password?(session_params[:password])
  end

  def user
    @user ||= User.find_by(email: session_params[:email])
  end

  def authenticated_user_preventor?
    web_user.present? &&
      web_user.valid_password?(params[:user][:password]) &&
      web_user.role_preventor?
  end

  def web_user
    @web_user ||= User.find_by(email: params[:user][:email])
  end

  def session_params
    params.require(:session).permit(:email, :password)
  end
end
