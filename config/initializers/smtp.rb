# frozen_string_literal: true

Rails.application.config.action_mailer.smtp_settings = {
  authentication: :plain,
  address: ENV.fetch('SMTP_ADDRESS', 'localhost'),
  from: ENV.fetch('SMTP_FROM', 'alert@noty.im'),
  port: 587,
  domain: ENV.fetch('SMTP_DOMAIN', 'localhost'),
  user_name: ENV.fetch('SMTP_USER_NAME', 'noty'),
  password: ENV.fetch('SMTP_PASSWORD', 'noty')
}
