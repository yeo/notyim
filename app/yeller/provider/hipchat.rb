# frozen_string_literal: true

require_relative 'base'

module Yeller
  module Provider
    class Hipchat < Base
      Yeller::Provider.register(self)

      configure do
        label! 'Room'
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        notification = Exception.new(
          message: 'Remove HipChat Usage',
          user: receiver.user.id.to_s,
          incident: incident.id.to_s
        )

        Bugsnag.notify(notification)
      end
    end
  end
end
