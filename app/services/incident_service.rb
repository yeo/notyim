class IncidentService
  # Create an open incident
  def self.create(assertion, params)
    incident = Incident.new(status: Incident::STATUS_OPEN)
    incident.check = assertion.check
    incident.assertion = assertion
    incident.save!
  end
end
