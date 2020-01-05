# frozen_string_literal: true

require 'trinity/decorator'

module Yeller
  module Provider
    class Base
      extend ::Trinity::Decorator

      def self.identity
        name.split('::').last
      end

      def self.log_notification(incident, message)
        n = Notification.new(message: message, kind: identity)
        incident.notifications << n
        incident.save!

        n
      end

      # Label is used to display as the label of provider when rendering field
      #
      def self.label
        @__attributes ||= {}
        @__attributes[:label] || 'Friendly name'
      end

      # Support adding form or not
      #
      # If true, we will show a form to add it
      # It's true by defaut, other provider has its own flow can set this to false
      def self.support_add_form?
        true
      end

      # Auto assign to check receiver list after creating
      def self.auto_assign_after_create?
        false
      end

      def self.allow_edit?
        true
      end

      # Get notification class of this provider
      # def self.notify_class
      #  "Yeller::Notify::#{identity.camelize}".constantize
      # end

      # Configure what to do with this provider
      def self.configure
        @__attributes = {}
        yield if block_given?
      end

      # Customize label name
      def self.label!(text)
        @__attributes[:label] = text
      end

      # Require verification will force this provide to confirm a code
      def self.require_verify!
        @__attributes[:require_verify] = true
      end

      # Does this provider require verificaion
      def self.require_verify?
        @__attributes[:require_verify] == true if @__attributes
      end

      # Require verification with code(Interactive)
      def self.require_input_verification_code!
        @__attributes[:require_input_verification_code] = true
      end

      # DOes this require verification with code (Interactive)
      def self.require_input_verification_code?
        @__attributes[:require_input_verification_code] if @__attributes
      end

      # Create a verification request
      # This can be send out an email for them to lick on link,
      # or send sms code so they enter on the site
      def self.create_verification_request!(_receiver)
        raise 'Please implement'
      end

      # Confirm verification
      def self.acknowledge_verification(_receiver)
        raise 'Please implement'
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      def self.notify_incident(_receiver, _incident)
        raise 'Please implement'
      end

      # Send welcome message
      def self.notify_welcome(_receiver)
        raise 'Please implement'
      end
    end
  end
end
