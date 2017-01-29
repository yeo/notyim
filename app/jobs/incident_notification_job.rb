class IncidentNotificationJob < ApplicationJob
  queue_as :default

  # @param Incident|int Incident id
  def perform(incident)
    incident = Incident.find(incident) if incident.is_a?(String)

  end
end
