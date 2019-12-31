# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # RFC 2822 requires that message-id match the from domain
  # We're using SendGrid and the from domain is convert into [sendgrid-id]-[our-selected-subdomain]
  DOMAIN = Rails.application.config.action_mailer.smtp_settings[:from].split("@").last
  default(from: Rails.application.config.action_mailer.smtp_settings[:from],
          reply_to: 'hello@noty.im',
          'Message-ID' => -> { "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@#{DOMAIN}" })

  layout 'mailer'
end
