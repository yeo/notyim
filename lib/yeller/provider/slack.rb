# frozen_string_literal: true

require_relative 'base'

module Yeller
  module Provider
    class Slack < Base
      Yeller::Provider.register(self)

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        incident = decorate(incident)
        notifier = ::Slack::Notifier.new receiver.handler
        # #{incident.short_summary_plain}
        notifier.ping <<~HEREDOC
          #{incident.subject}
           Service: #{incident.check.uri}
          Incident Detail: #{incident.url}
           Reason: #{incident.reason}
        HEREDOC
      end
    end
  end
end
