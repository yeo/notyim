# frozen_string_literal: true

Raven.configure do |config|
  config.dsn = ENV['SENTRY_DSN'] || Rails.application.credentials[:SENTRY_DSN]
  config.release = ENV['GIT_COMMIT'] || 'master'
end
