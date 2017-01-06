Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = {
  :authentication => :plain,
  :address => ENV.fetch("SMTP_ADDRESS"),
  :port => 587,
  :domain => ENV.fetch("SMTP_DOMAIN"),
  :user_name => ENV.fetch("SMTP_USER_NAME"),
  :password => ENV.fetch("SMTP_PASSWORD"),
}
