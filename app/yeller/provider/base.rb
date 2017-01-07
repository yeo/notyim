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

      def self.create_verification_request!(receiver)
        raise "Please implement"
      end

      # verification by interactive request, mean entering an user input
      def self.interactive_request

      end
    end
  end
end
