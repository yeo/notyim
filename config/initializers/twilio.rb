# frozen_string_literal: true

# alternatively, you can preconfigure the client like so
Rails.configuration.twilio = { from: ENV.fetch('PHONE_FROM', Rails.application.credentials[:PHONE_FROM]) }
Twilio.configure do |config|
  config.account_sid = ENV.fetch('TWILIO_ACCOUNT_SID', Rails.application.credentials[:TWILIO_ACCOUNT_SID])
  config.auth_token = ENV.fetch('TWILIO_AUTH_TOKEN', Rails.application.credentials[:TWILIO_AUTH_TOKEN])
end
