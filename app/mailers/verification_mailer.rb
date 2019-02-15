# frozen_string_literal: true

class VerificationMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def confirm_contact(receiver)
    @receiver = Receiver.find(receiver)
    @verification = @receiver.last_verification
    @url = [verify_verification_url(@verification), '?code=', @verification.code].join('')
    mail(to: @receiver.handler, subject: 'Please confirm your email alert contact')
  end

  def acknowledge(receiver)
    @receiver = Receiver.find(receiver)
    @verification = @receiver.last_verification
    @url = [verify_verification_url(@verification), '?code=', @verification.code].join('')
    mail(to: @receiver.handler, subject: 'Your email alert contact is confirm')
  end
end
