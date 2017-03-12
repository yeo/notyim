module Yeller
  module Transporter
    class SmsTest < Sms
      def self.client
        @__test_client = Twilio::REST::Client.new ENV['TWILIO_TEST_ACCOUNT_SID'], ENV['TWILIO_TEST_AUTH_TOKEN']
      end

      def self.send(to, body, from=nil)
        super.send(to, body, ENV['PHONE_FROM_TEST'])
      end
    end
  end
end
