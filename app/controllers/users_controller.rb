class UsersController < ApplicationController
  # skip_before_action :current_user, :authenticate_request, only: [:reset_password]

  # TODO: Definir si se implementara el CU de cambiar password
  def update_password
    return render_error_invalid_current_password unless valid_current_password?
    if user.update_attributes(password_params.slice(:password, :password_confirmation))
      unless user.try(:send_password_change_notification)
        return render_error('invalid-email', :not_found)
      end
      head :ok
    else
      render_error(user.errors.full_messages, :unprocessable_entity)
    end
  end

  # def reset_password
  #   user_by_email.try(:send_reset_password_instructions) ||
  #   render_error('invalid-email', :not_found)
  # end
  def reset_password
    user_by_email.try(:reset_password) ||
      render_error('invalid-email', :not_found)
  end

  private

  def render_error_invalid_current_password
    render_error('invalid-current-password', :unprocessable_entity)
  end

  def password_params
    params.require(:user).require(:current_password)
    params.require(:user).require(:password)
    params.require(:user).require(:password_confirmation)
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def valid_current_password?
    user.valid_password?(password_params[:current_password])
  end

  def user
    return render_error('must send user_id header', :bad_request) if user_id_header.blank?
    @current_user ||= User.find(user_id_header)
  end

  def user_id_header
    return nil unless headers['user_id'].present?
    @user_id_header = headers['user_id']
  end

  def user_by_email
    @user_by_email ||= User.find_by(email: params[:user_email])
  end
end
