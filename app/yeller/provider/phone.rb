# frozen_string_literal: true

require_relative 'base'
require 'trinity/utils/url'

module Yeller
  module Provider
    class Phone < Base
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
        verification = receiver.last_verification
        raise MissingUserForReceiver unless user

        url = Trinity::Utils::Url.to(:interactive_voice_verification, verification)
        ::Yeller::Transporter::Phone.call(receiver.handler, url)
      end

      def self.acknowledge_verification(receiver)
        # No need to to acknowledge since user interactive with the phone
      end

      # Create call request to notify incident
      def self.notify_incident(incident, receiver)
        # TODO: we should make sure phone # is valid to avoid waste money
        incident = decorate(incident)
        content = <<~HEREDOC
          #{incident.short_summary}
          Service: #{incident.check.uri}
            #{incident.assertion.condition}
            is #{incident.assertion.operand}
        HEREDOC

        n = log_notification(incident, content)
        url = Trinity::Utils::Url.to(:incident_voice, incident)

        user = incident.user
        if user.internal_tester?
          ::Yeller::Transporter::PhoneTest.call(receiver.handler, url)
        else
          if TeamCreditService.has_credit_voice?(incident.team)
            TeamCreditService.deduct_voice_minute!(incident.team)

            PhoneTransporterWorker.perform_async receiver.id.to_s, url
          else
            e = Exception.new(message: 'no voice balance', user: user.id.to_s)
            Bugsnag.notify e
            return nil
          end
        end
      end

      # Render twilio for incident call
      def self.incident_twilio_notification(incident)
        notification = incident.notifications.where(kind: identity).desc(:id).first

        response = Twilio::TwiML::Response.new do |r|
          r.Say notification.message, voice: 'alice'
        end

        response.text
      end
    end
  end
end
