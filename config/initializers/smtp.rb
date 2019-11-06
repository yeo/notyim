# frozen_string_literal: true

Rails.application.config.action_mailer.smtp_settings = {
  authentication: :plain,
  address: ENV['SMTP_ADDRESS'] || Rails.application.credentials[:SMTP_ADDRESS],
  from: ENV.fetch('SMTP_FROM', 'oncall@alert.noty.im'),
  port: 587,
  domain: ENV['SMTP_DOMAIN'] || Rails.application.credentials[:SMTP_DOMAIN],
  user_name: ENV['SMTP_USER_NAME'] || Rails.application.credentials[:SMTP_USER_NAME],
  password: ENV['SMTP_PASSWORD'] || Rails.application.credentials[:SMTP_PASSWORD]
}
