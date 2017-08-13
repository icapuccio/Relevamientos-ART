require_relative 'boot'

require 'rails'
# Pick the frameworks you want:
require 'active_model/railtie'
require 'active_job/railtie'
require 'active_record/railtie'
require 'action_controller/railtie'
require 'action_mailer/railtie'
require 'action_view/railtie'
require 'action_cable/engine'
require 'sprockets/railtie'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RelevamientosArt
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Sets the default time zone to Buenos Aires
    config.time_zone = "America/Argentina/Buenos_Aires"

    config.generators do |g|
      g.test_framework :rspec
    end

    if Rails.application.secrets.email_recipients_interceptors.present?
      Mail.register_interceptor RecipientInterceptor.new(
        Rails.application.secrets.email_recipients_interceptors,
        subject_prefix: '[INTERCEPTOR]'
      )
    end
  end
end
