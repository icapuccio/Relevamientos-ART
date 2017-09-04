class ApplicationController < ActionController::Base
  rescue_from ActionController::ParameterMissing, with: :render_incorrect_parameter
  rescue_from ActionController::UnpermittedParameters, with: :render_incorrect_parameter
  rescue_from ActiveRecord::RecordNotFound, with: :render_nothing_not_found
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  # TODO: Quitar el salteo ante un request JSON
  #   http://jessewolgamott.com/blog/2012/01/19/the-one-with-a-json-api-login-using-devise
  before_action :authenticated_user!, except: [:new, :create], unless: :json_request?

  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  # before_action :set_locale
  #
  # def set_locale
  #   I18n.locale = params[:locale] || I18n.default_locale
  # end
  #
  # def default_url_options
  #   { locale: locale }
  # end
  #
  # # for devise to redirect with locale
  # def self.default_url_options(options = {})
  #   options.merge(locale: I18n.locale)
  # end

  protected

  def authenticated_user!
    if user_signed_in?
      authenticate_user!
    else
      respond_to do |format|
        flash[:alert] = I18n.t('devise.failure.unauthenticated')
        format.html { redirect_to login_path }
        ## if you want render 404 page
        ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404,
        ##         :layout => false
      end
    end
  end

  private

  def json_request?
    request.format == 'json'
  end

  # Serializer methods
  def default_serializer_options
    { root: false }
  end

  # TODO: Revisar si esto va a ser necesario usar o no
  # alias devise_current_user current_user
  # def current_user
  #   if user_id_header.blank?
  #     devise_current_user
  #   else
  #     @current_user ||= User.find(user_id_header)
  #   end
  # end
  #
  # def user_id_header
  #   return nil unless headers['user_id'].present?
  #   @user_id_header = headers['user_id']
  # end

  def render_nothing_not_found
    head :not_found
  end

  def render_incorrect_parameter(error)
    render json: { error: error.message }, status: :bad_request
  end
end
