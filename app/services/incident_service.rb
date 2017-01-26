class IncidentService
  # Create an open incident
  def self.create_for_assertion(assertion, check_result)
    incident = Incident.new(status: Incident::STATUS_OPEN)
    incident.check = assertion.check
    incident.assertion = assertion
    incident.save!
  end

  # Setup notification for a given incident
  def self.setup_for_open(incident, new_status)
    # TODO If user has not setup receivers, then default to their email
    incident.check.receivers.each do
      
    end
  end

  def self.setup_for_close(incident, new_status)

  end
end
