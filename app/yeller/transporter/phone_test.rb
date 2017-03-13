module Yeller
  module Transporter
    class PhoneTest
      def self.client
        @__test_client = Twilio::REST::Client.new ENV['TWILIO_TEST_ACCOUNT_SID'], ENV['TWILIO_TEST_AUTH_TOKEN']
      end

      def self.call(to, url, from = nil, method: 'GET'.freeze)
        super to, url, from || ENV['PHONE_FROM_TEST'], method: method
      end
    end
  end
end
