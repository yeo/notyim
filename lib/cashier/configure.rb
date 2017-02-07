require 'cashier/subscription'
require 'cashier/package'

module Cashier
  class Configure
    attr_reader :packages
    attr_reader :subscriptions
    attr_reader :sms_price, :minute_price

    def sms_price(p)
      @sms_price = p
    end

    def minute_price(p)
      @minute_price = p
    end

    def subscription(name, price, opts = {})
      @subscriptions ||= Hash.new
      @subscriptions[name] = Subscription.new(name, price, opts)
    end

    def package(name, price, opts = {})
      @packages ||= Hash.new
      @packages[name] = Package.new(name, price, opts)
    end
  end
end
