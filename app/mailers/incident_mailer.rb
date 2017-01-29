class IncidentMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def notify(receiver, incident)
    @receiver = receiver
    @incident = incident
    #@url =  [verify_verification_url(@verification), "?code=", @verification.code].join('')
    mail(to: @receiver.handler, subject: incident.short_summary)
  end
end
