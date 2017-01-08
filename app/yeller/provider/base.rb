module Yeller
  module Provider
    class Base
      def self.identity
        name.split('::').last
      end

      def self.configure
        @__attributes = {}
        yield if block_given?
      end

      def self.require_verify!
        @__attributes[:require_verify] = true
      end

      def self.require_verify?
        if @__attributes
          @__attributes[:require_verify] == true
        end
      end

      def self.require_input_verification_code!
        @__attributes[:require_input_verification_code] = true
      end

      def self.require_input_verification_code?
        if @__attributes
          @__attributes[:require_input_verification_code]
        end
      end

      def self.create_verification_request!(receiver)
        raise "Please implement"
      end

      def self.acknowledge_verification(receiver)
        raise "Please implement"
      end
    end
  end
end
