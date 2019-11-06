require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
# require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
# require "action_mailbox/engine"
# require "action_text/engine"
require "action_view/railtie"
require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Trinity
  class Application < Rails::Application
    config.load_defaults 6.0

    # Custom configuration
    # Those setting isn't on Rails, we store theme here to access them later on
    # Those need to take care when we update Rails
    config.local_proxy_public = ENV.fetch('DEV_TUNNEL_ADDRESS', 'noty.im')
    # How many location need to match in order to confirm that an incident has occured
    config.incident_confirm_location = 1
    config.incident_notification_interval = 10.minutes
    config.telegram_bot = {
      name: 'notydevbot'
    }
    config.slack_bot = {
      scope: 'bot',
      client_id: '51439348069.157091434678',
      redirect_uri: 'http://127.0.0.1:3000/bot/slack',
      client_secret: ENV.fetch('SLACK_CLIENT_SECRET', Rails.application.credentials.fetch(:SLACK_CLIENT_SECRET))
    }
    # End custom configuration

    #ActiveSupport::Dependencies.autoload_paths.delete("#{Rails.root}/app/yeller")
  end
end
