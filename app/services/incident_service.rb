require 'trinity'

class IncidentService

  attr_reader :incident
  def initialize(incident)
    @incident = incident
  end

  # Create an open incident for given assertion and check result
  # and setup the flow of incident open
  #
  # @param Assertion
  # @param CheckResponse check_response
  # @return Incident|Bool
  #         incident which was created
  #         false not create an incident, an ongoing aleady has
  def self.create_for_assertion(assertion, check_response)
    incident = assertion.ongoing_incident
    if incident
      # TODO Probably do something for stil down/still happen incident notification
      if !incident.locations.any? { |where| where[:ip] == check_response.from_ip }
        incident.locations << {ip: check_response.from_ip, message: check_response.error_message}
        incident.locations = incident.locations.uniq { |l| l[:ip] }
        incident.save
      end
    else
      Trinity::Semaphore.run_once [assertion.check.id.to_s, assertion.id.to_s] do
        incident = open_incident(assertion, check_response)
      end
    end

    if incident.locations.length >= Rails.configuration.incident_confirm_location
      incident.status = Incident::STATUS_OPEN
      incident.save
    end

    notify(incident, Incident::STATUS_OPEN) if incident.open?
    incident
  end

  # Close an incident and trigger its flow
  # @param Incident
  def self.close(incident)
    close_incident(incident)
    notify incident, Incident::STATUS_CLOSE
  end

  # Create an open incident.
  # @param Assertion assertion
  # @CheckResponse check response
  # @return Incident created incident
  def self.open_incident(assertion, check_result)
    incident = Incident.new(status: Incident::STATUS_PARTIAL, check: assertion.check, user: assertion.check.user, error_message: check_result.error_message, locations: [{ip: check_result.from_ip, message: check_result.error_message}])

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
