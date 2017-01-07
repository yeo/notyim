require_relative 'base'

module Yeller
  module Provider
    class Sms < Base
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
    end
  end
end
