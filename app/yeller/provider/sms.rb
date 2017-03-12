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
        if user.internal_tester?
          ::Yeller::Transporter::SmsTest.send(receiver.handler, "Your noty.im verification code: #{receiver.last_verification.code}.\n")
        else
          ::Yeller::Transporter::Sms.send(receiver.handler, "Your noty.im verification code: #{receiver.last_verification.code}.\n")
        end
      end

      def self.acknowledge_verification(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user
        # TODO: maybe queue this in future
        if user.internal_tester?
          ::Yeller::Transporter::SmsTest.send(receiver.handler, "You are all set. We'll message to this number.")
        else
          ::Yeller::Transporter::Sms.send(receiver.handler, "You are all set. We'll message to this number.")
        end
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        #TODO we should make sure phone # is valid to avoid waste money
        incident = decorate(incident)
        content = <<~HEREDOC
        #{incident.short_summary}
        Service: #{incident.check.uri}
        Type: #{incident.assertion.subject}
        Condition: #{incident.assertion.condition}
        Match: #{incident.assertion.operand}
        HEREDOC
        user = incident.user

        if user.internal_tester?
          ::Yeller::Transporter::SmsTest.send(receiver.handler, content)
        else
          if UserCreditService.has_credit_sms?(user)
            UserCreditService.deduct_sms!(user)
            ::Yeller::Transporter::Sms.send(receiver.handler, content)
          else
            e = Exception.new(message: 'no sms balance', user: user.id.to_s)
            Bugsnag.notify e
            return nil
          end
        end
      end

    end
  end
end
