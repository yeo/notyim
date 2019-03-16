# frozen_string_literal: true

Bugsnag.configure do |config|
  config.api_key = ENV['BUGSNAG_KEY']
  config.app_version = ENV['GIT_COMMIT'] || 'master'
end
