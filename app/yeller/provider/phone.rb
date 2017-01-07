require_relative 'base'
require 'trinity/utils/url'

module Yeller
  module Provider
    class Phone < Base
      Yeller::Provider.register(self)

      configure do
        require_verify!
      end

      # Generate a verification code
      # @param Receiver object
      def self.generate_code(receiver)
        (Random.rand * 1000000).round
      end

      def self.create_verification_request!(receiver)
        user = receiver.user
        verification = receiver.last_verification
        raise MissingUserForReceiver unless user
        url = Trinity::Utils::Url.to(:interactive_voice_verification, verification)
        Yeller::Transporter::Phone.call(receiver.handler, url)
      end

      def self.acknowledge_verification(receiver)
        # No need to to acknowledge since user interactive with the phone
      end
    end
  end
end
