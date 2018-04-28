# alternatively, you can preconfigure the client like so
Rails.configuration.twilio = { from: ENV.fetch('PHONE_FROM', nil) }
Twilio.configure do |config|
  config.account_sid = ENV.fetch('TWILIO_ACCOUNT_SID', nil)
  config.auth_token = ENV.fetch('TWILIO_AUTH_TOKEN', nil)
end
