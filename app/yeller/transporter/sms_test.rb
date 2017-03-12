module Yeller
  module Transporter
    class SmsTest < Sms
      def self.client
        @__test_client = Twilio::REST::Client.new ENV['TWILIO_TEST_ACCOUNT_SID'], ENV['TWILIO_TEST_AUTH_TOKEN=']
      end
    end
  end
end
