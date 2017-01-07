require_relative 'base'
require 'securerandom'

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
    end
  end
end
