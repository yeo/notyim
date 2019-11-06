# frozen_string_literal: true

require_relative 'base'

module Yeller
  module Provider
    class SlackBot < Base
      Yeller::Provider.register(self)

      def self.allow_edit?
        false
      end

      def self.support_add_form?
        false
      end

      def self.auto_assign_after_create?
        false
      end

      # Send out notification for an incident. This is
      # a complex logic including
      #   - generate the message
      #   - fanout the message to receiver
      # @param Receiver receiver
      # @param Incident incident
      def self.notify_incident(incident, receiver)
        text, attachments, icon = prepare_slack_payload(decorate(incident))

        notifier = ::Slack::Notifier.new receiver.provider_params['incoming_webhook']['url']
        notifier.post(text: text, attachments: attachments, icon_emoji: icon)
      end

      def self.prepare_slack_payload(incident)
        text = <<~HEREDOC
          #{incident.subject}
           #{incident.short_summary_plain}
           Incident Detail: #{incident.url}
           Reason: #{incident.reason}
        HEREDOC

        attachments = {
          fallback: "Service: #{incident.check.uri}",
          text: "Service: #{incident.check.uri}",
          color: incident.close? ? 'green' : 'red'
        }
        icon = incident.close? ? ':white_check_mark:' : ':fire:'

        [text, attachments, icon]
      end
      private_class_method :prepare_slack_payload

      def self.notify_welcome(receiver)
        notifier = ::Slack::Notifier.new receiver.provider_params['incoming_webhook']['url']
        text = <<~HEREDOC
          Welcome to noty.im. You are all set. We will notify this channel when incident occurs.
        HEREDOC

        attachments = {
          fallback: 'Learn more from our doc https://noty.im/docs',
          text: 'Learn more from our doc https://noty.im/docs',
          color: 'green'
        }

        notifier.post(text: text, attachments: attachments, icon_emoji: ':wave:')
      end
    end
  end
end
