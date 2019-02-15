# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  # TODO: Remove hard code domain
  default(from: Rails.application.config.action_mailer.smtp_settings[:from],
          'Message-ID' => -> { "#{Digest::SHA2.hexdigest(Time.now.to_i.to_s)}@noty.im" })

  layout 'mailer'
end
