# frozen_string_literal: true

module Yeller
  module Transporter
    class Sms
      def self.client
        @__client = Twilio::REST::Client.new
      end

      # Send SMS
      # @param string dest eg +1408111111
      # @param body
      # @param string from take from config if not specififying
      def self.send(to, body, from = nil)
        from = Rails.configuration.twilio[:from] unless from.present?
        to = "+1#{to}" unless to.start_with?('+')

        client.messages.create(
          from: from,
          to: to,
          body: body
        )
      end
    end
  end
end
