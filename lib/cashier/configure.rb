require 'cashier/subscription'
require 'cashier/package'

module Cashier
  class Configure
    attr_reader :packages
    attr_reader :subscriptions
    attr_reader :sms_price, :minute_price
    attr_reader :exchange_rate # value of 1 cents to our credit

    def exchange_rate(v)
      @exchange_rate = v
    end

    def sms_price(p)
      @sms_price = p
    end

    def minute_price(p)
      @minute_price = p
    end

    def subscription(name, price, opts = {})
      @subscriptions ||= Hash.new
      @subscriptions[name.to_s] = Subscription.new(name, price * 100, opts)
    end

    def package(name, price, opts = {})
      @packages ||= Hash.new
      @packages[name.to_s] = Package.new(name, price * 100, opts)
    end
  end
end
