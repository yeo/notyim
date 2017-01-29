module Yeller
  module Provider
    class Base
      def self.identity
        name.split('::').last
      end

      # Get notification class of this provider
      #def self.notify_class
      #  "Yeller::Notify::#{identity.camelize}".constantize
      #end

      # Configure what to do with this provider
      def self.configure
        @__attributes = {}
        yield if block_given?
      end

      # Require verification will force this provide to confirm a code
      def self.require_verify!
        @__attributes[:require_verify] = true
      end

      # Does this provider require verificaion
      def self.require_verify?
        if @__attributes
          @__attributes[:require_verify] == true
        end
      end

      # Require verification with code(Interactive)
      def self.require_input_verification_code!
        @__attributes[:require_input_verification_code] = true
      end

      # DOes this require verification with code (Interactive)
      def self.require_input_verification_code?
        if @__attributes
          @__attributes[:require_input_verification_code]
        end
      end

      # Create a verification request
      # This can be send out an email for them to lick on link,
      # or send sms code so they enter on the site
      def self.create_verification_request!(receiver)
        raise "Please implement"
      end

      # Confirm verification
      def self.acknowledge_verification(receiver)
        raise "Please implement"
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      def self.notify_incident(receiver, incident)
        raise "Please implement"
      end
    end
  end
end
