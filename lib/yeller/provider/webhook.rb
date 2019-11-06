# frozen_string_literal: true

require_relative 'base'
require 'net/http'
require 'uri'

module Yeller
  module Provider
    class Webhook < Base
      Yeller::Provider.register(self)

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        incident = decorate(incident)
        payload = {
          id: incident.check.id,
          uri: incident.check.uri,
          message: <<~HEREDOC
            #{incident.subject}
            #{incident.short_summary}
             Service: #{incident.check.uri}
            Incident detail: #{incident.url}
             #{incident.reason}
          HEREDOC
        }
        Net::HTTP.post_form URI(receiver.handler), payload
      end
    end
  end
end
