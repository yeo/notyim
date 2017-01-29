class IncidentService
  # Create an open incident for given assertion and check result
  # and setup the flow of incident open
  #
  # @param Assertion
  # @param CheckResponse check_response
  def self.create_for_assertion(assertion, check_response)
    incident = open_incident(assertion, check_response)
    notify incident, Incident::STATUS_OPEN
  end

  # Close an incident and trigger its flow
  # @param Incident
  def self.close(incident)
    close_incident(incident)
    notify Incident::STATUS_CLOSE
  end

  # Create an open incident.
  # @param Assertion assertion
  # @CheckResponse check response
  # @return Incident created incident
  def self.open_incident(assertion, check_result)
    incident = Incident.new(status: Incident::STATUS_OPEN)
    incident.assertion = assertion
    incident.save!

    incident
  end

  # Close an incident
  #
  # Set status of incident to close. Don't trigger any notification flow
  # @param Incident incident
  def self.close_incident(incident)
    incident.status = Incident::STATUS_CLOSE
    incident.save!

    incident
  end

  # Send notification to receivers that register on the checks
  def self.notify(incident, new_status)
    # TODO If user has not setup receivers, then default to their email
    incident.check.fetch_receivers.
      map { |receiver| NotifyReceiverService.new incident, receiver }.
      each(&:execute)
  end
end
