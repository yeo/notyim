require_relative 'base'
require 'securerandom'
require 'trinity/decorator'

module Yeller
  module Provider
    class MissingUserForReceiver < StandardError; end

    class Email < Base
      Yeller::Provider.register(self)
      include Rails.application.routes.url_helpers

      configure do
        require_verify!
      end

      # Generate a verification code
      # @param Receiver object
      def self.generate_code(receiver)
        SecureRandom.hex
      end

      def self.create_verification_request!(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user
        # TODO: maybe queue this in future
        VerificationMailer.confirm_contact(receiver.id.to_s).deliver_now
      end

      def self.acknowledge_verification(receiver)
        user = receiver.user
        raise MissingUserForReceiver unless user
        # TODO: maybe queue this in future
        VerificationMailer.acknowledge(receiver.id.to_s).deliver_now
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        incident = ::Trinity::Decorator.for(incident)
        IncidentMailer.notify(receiver, incident).deliver
      end
    end
  end
end
