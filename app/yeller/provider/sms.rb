require_relative 'base'

module Yeller
  module Provider
    class Sms < Base
      Yeller::Provider.register(self)

      configure do
        require_verify!
        require_input_verification_code!
      end

      # Generate a verification code
      # @param Receiver object
      def self.generate_code(receiver)
        (Random.rand * 1000000).round
      end

      def self.create_verification_request!(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user
        # TODO: maybe queue this in future
        Yeller::Transporter::Sms.send(receiver.handler, "Hi, enter this code to cofirm your account: #{receiver.last_verification.code}.\n")
      end

      def self.acknowledge_verification(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user
        # TODO: maybe queue this in future
        Yeller::Transporter::Sms.send(receiver.handler, "Hi, your phone number is confirm. Alert will be alow to send to this number")
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        #TODO we should make sure phone # is valid to avoid waste money
        incident = ::Trinity::Decorator.for(incident)
        content = <<~HEREDOC
        #{incident.short_summary}
        Service: #{incident.check.uri}
        Type: #{incident.assertion.subject}
        Condition: #{incident.assertion.condition}
        Match: #{incident.assertion.operand}
        HEREDOC

        Yeller::Transporter::Sms.send(receiver.handler, content)
      end

    end
  end
end
