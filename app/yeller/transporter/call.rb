module Yeller
  module Transporter
    class Phone
      def self.client
        @__client = Twilio::REST::Client.new
      end

      #Send SMS
      #@param string dest eg +1408111111
      #@param string twiml url
      #@param string from take from config if not specififying
      def self.call(to, url, from=nil, method: 'GET'.freeze)
        from = Rails.configuration.twilio[:from] unless from.present?
        to = "+1#{to}" unless to.start_with?('+')

        call = client.calls.create(
          :from => from,
          :to => to,
          :url => url,
          :method => method
        )

        call
      end
    end
  end
end
