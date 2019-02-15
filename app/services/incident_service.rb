# frozen_string_literal: true

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
    incident = (assertion.partial_incidents.first || assertion.ongoing_incident)

    if incident
      # TODO: Probably do something for stil down/still happen incident notification
      if incident.locations['open'].none? { |where| where[:ip] == check_response.from_ip }
        incident.locations['open'] << { ip: check_response.from_ip, message: check_response.error_message || check_response.body }
        incident.locations['open'] = incident.locations['open'].uniq { |l| l[:ip] }
      end
    else
      Trinity::Semaphore.run_once [assertion.check.id.to_s, assertion.id.to_s] do
        incident = open_incident(assertion, check_response)
      end
    end

    return unless incident

    if (incident.locations['open'].try(:length) || 0) >= Rails.configuration.incident_confirm_location &&
       (Time.now - incident.created_at >= 2.minute)
      incident.status = Incident::STATUS_OPEN
    end
    incident.save!

    if incident.open?
      Trinity::Semaphore.run_once ['alert', 'open', assertion.check.id.to_s, incident.id.to_s], Rails.configuration.incident_notification_interval.to_i do
        notify(incident, Incident::STATUS_OPEN)
      end
    end

    incident
  end

  # Close an incident for given assertion and check response
  #
  # When all location is closed, we will send incident close notification
  #
  # @param Assertion assertion
  # @param CheckResponse check_response
  def self.close_for_assertion(assertion, check_response)
    unless (partial_incidents = assertion.partial_incidents).empty?
      # Since this is partial incident, just delete them
      partial_incidents.each(&:destroy)
      return
    end

    # Check doesn't match, and we have an on-going incident, this mean we can close it
    if incident = assertion.ongoing_incident
      if incident.locations['close'].none? { |where| where[:ip] == check_response.from_ip }
        incident.locations['close'] << { ip: check_response.from_ip, message: check_response.error_message }
      end
    else
      return
    end

    open_locations = incident.locations['open'].map { |l| l[:ip].strip }
    close_locations = incident.locations['close'].map { |l| l[:ip].strip }

    # the best
    if (open_locations - close_locations).empty? || (incident.locations['close'].try(:length) || 0) >= Rails.configuration.incident_confirm_location
      close_incident incident
    end

    if incident.close?
      Trinity::Semaphore.run_once ['alert', 'close', assertion.check.id.to_s, incident.id.to_s], Rails.configuration.incident_notification_interval.to_i do
        notify incident, Incident::STATUS_CLOSE
      end
    end

    incident.save!

    incident
  end

  # Create an open incident.
  # @param Assertion assertion
  # @CheckResponse check response
  # @return Incident created incident
  def self.open_incident(assertion, check_result)
    incident = Incident.new(
      status: Incident::STATUS_PARTIAL,
      check: assertion.check,
      user: assertion.check.user,
      team: assertion.check.team,
      error_message: check_result.error_message,
      locations: { open: [{ ip: check_result.from_ip, message: check_result.error_message }], close: [] }
    )

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
    incident.closed_at = Time.now.utc
    incident.save!

    incident
  end

  # Send notification to receivers that register on the checks
  def self.notify(incident, _new_status)
    # TODO: If user has not setup receivers, then default to their email
    if (receivers = incident.check.fetch_receivers).present?
      receivers.each { |receiver| NotifyReceiverService.execute incident, receiver }
    else
      receiver = Receiver.new(
        provider: 'Email',
        name: incident.check.user.email,
        handler: incident.check.user.email,
        require_verify: false, verified: true
      )
      NotifyReceiverService.execute(incident, receiver)
    end
  end
end
