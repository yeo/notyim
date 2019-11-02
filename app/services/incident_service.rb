# frozen_string_literal: true

require 'trinity'

class IncidentService
  INCIDENT_ALERT_INTERVAL = Rails.configuration.incident_notification_interval.to_i
  DOWNLOCATION_THRESHOLD = Rails.configuration.incident_confirm_location

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
    return unless (incident = create_incident_or_attach_down_location(assertion, check_response))

    if (incident.locations['open'].try(:length) || 0) >= Rails.configuration.incident_confirm_location &&
       (Time.now - incident.created_at >= 2.minute)
      incident.status = Incident::STATUS_OPEN
    end
    incident.save!

    notify_open_incident(incident)

    incident
  end

  def notify_open_incident(incident)
    return unless incident.open?

    action = ['alert', 'open', assertion.check.id.to_s, incident.id.to_s]
    Trinity::Semaphore.run_once(action, INCIDENT_ALERT_INTERVAL) { notify(incident, Incident::STATUS_OPEN) }
  end

  def self.create_incident_or_attach_down_location(assertion, check_response)
    incident = (assertion.partial_incidents.first || assertion.ongoing_incident)

    return attach_down_location_to_incident(incident, check_response) if incident

    action = [assertion.check.id.to_s, assertion.id.to_s]
    Trinity::Semaphore.run_once(action) { open_incident(assertion, check_response) }
  end

  def self.attach_down_location_to_incident(incident, check_response)
    # TODO: Probably do something for stil down/still happen incident notification
    down_location = { ip: check_response.from_ip, message: check_response.error_message || check_response.body }
    incident.locations['open'] << down_location
    incident.locations['open'] = incident.locations['open'].uniq { |l| l[:ip] }

    incident
  end

  # Close an incident for given assertion and check response
  #
  # When all location is closed, we will send incident close notification
  #
  # @param Assertion assertion
  # @param CheckResponse check_response
  def self.close_for_assertion(assertion, check_response)
    return if close_partial_incident(assertion)

    # Check doesn't match, and we have an on-going incident, this mean we can close it
    incident = assertion.ongoing_incident
    return unless incident

    # if incident.locations['close'].none? { |where| where[:ip] == check_response.from_ip }
    unless close_incident_from_ip?(incident, check_response.from_ip)
      incident.locations['close'] << { ip: check_response.from_ip, message: check_response.error_message }
    end

    check_and_close_incident!(incident, assertion)

    incident
  end

  def self.check_and_close_incident!(incident, assertion)
    down_locations = find_ip_of_down_locations(incident)
    close_incident!(incident) if down_locations.length >= DOWNLOCATION_THRESHOLD
    alert_close_incident(incident, assertion) unless incident.close?

    incident.close?
  end

  def self.find_ip_of_down_locations(incident)
    down_location = incident.locations['open'].map { |l| l[:ip].strip } -
                    incident.locations['close'].map { |l| l[:ip].strip }
    down_location = incident.locations['close'] if down_location.empty?

    down_location
  end

  def self.alert_close_incident(incident, assertion)
    action = ['alert', 'close', assertion.check.id.to_s, incident.id.to_s]
    Trinity::Semaphore.run_once(action, INCIDENT_ALERT_INTERVAL) { notify incident, Incident::STATUS_CLOSE }
  end

  def self.close_partial_incident(assertion)
    partial_incidents = assertion.partial_incidents
    return false unless partial_incidents.present?

    # Since this is partial incident, just delete them
    partial_incidents.each(&:destroy)

    true
  end

  def self.close_incident_from_ip?(incident, ip)
    incident.locations['close'].any? { |where| where[:ip] == ip }
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

    incident.tap do
      incident.assertion = assertion
      incident.save!
    end
  end

  # Close an incident
  #
  # Set status of incident to close. Don't trigger any notification flow
  # @param Incident incident
  def self.close_incident!(incident)
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
