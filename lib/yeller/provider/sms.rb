# frozen_string_literal: true

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
      def self.generate_code(_receiver)
        (Random.rand * 1_000_000).round
      end

      def self.create_verification_request!(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user

        content = "Your noty.im verification code: #{receiver.last_verification.code}.\n"
        # TODO: maybe queue this in future
        if user.internal_tester?
          ::Yeller::Transporter::SmsTest.send(receiver.handler, content)
        else
          ::Yeller::Transporter::Sms.send(receiver.handler, content)
        end
      end

      def self.acknowledge_verification(receiver)
        # TODO: Use email to save SMS cost
        # Temp disable
        return if true # rubocop:disable Lint/LiteralAsCondition

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
        # TODO: we should make sure phone # is valid to avoid waste money
        incident = decorate(incident)
        content = <<~HEREDOC
          #{incident.short_summary}
          Service: #{incident.check.uri}
          Type: #{incident.assertion.subject}
          Condition: #{incident.assertion.condition}
          Match: #{incident.assertion.operand}
        HEREDOC

        log_notification(incident, content)

        perform_notify_incident(incident, receiver, content)
      end

      def self.perform_notify_incident(incident, receiver, content)
        return ::Yeller::Transporter::SmsTest.send(receiver.handler, content) if incident.user.internal_tester?

        unless TeamCreditService.enough_credit_sms?(incident.team)
          Raven.capture_exception(Exception.new(message: 'no sms balance', user: user.id.to_s))
          return
        end
        send_and_deduct_credit!(incident, receiver, content)
      end
      private_class_method :perform_notify_incident

      def self.send_and_deduct_credit!(incident, receiver, content)
        # TODO: Use mongodb4 transaction
        TeamCreditService.deduct_sms!(incident.team)
        ::Yeller::Transporter::Sms.send(receiver.handler, content)
      end
      private_class_method :send_and_deduct_credit!
    end
  end
end
