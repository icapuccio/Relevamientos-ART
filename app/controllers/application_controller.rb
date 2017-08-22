class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :null_session
  before_action :authenticate_user!

  # i18n configuration. See: http://guides.rubyonrails.org/i18n.html
  before_action :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def default_url_options
    { locale: locale }
  end

  # for devise to redirect with locale
  def self.default_url_options(options = {})
    options.merge(locale: I18n.locale)
  end

  private

  # Serializer methods
  def default_serializer_options
    { root: false }
  end

  alias devise_current_user current_user
  def current_user
    if user_id_header.blank?
      devise_current_user
    else
      @current_user ||= User.find(user_id_header)
    end
  end

  def user_id_header
    return nil unless headers['user_id'].present?
    @user_id_header = headers['user_id']
  end

  def index; end
end
