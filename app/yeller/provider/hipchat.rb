require_relative 'base'

module Yeller
  module Provider
    class Hipchat < Base
      Yeller::Provider.register(self)

      configure do
        label! "Room".freeze
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        client = HipChat::Client.new(receiver.handler, :api_version => 'v2')
        incident = decorate(incident)
        body = <<~HEREDOC
          incident.check.uri
          #{incident.short_summary}
          Condition: #{incident.assertion.condition}
          Match: #{incident.assertion.operand}

          #{incident.url}
        HEREDOC

        client[receiver.name].send("noty - [#{incident.status} alert]", body, message_format: 'text', color: incident.open? ? 'red' : 'green')
      end
    end
  end
end
