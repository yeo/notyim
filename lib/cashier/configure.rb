# frozen_string_literal: true

require 'cashier/subscription'
require 'cashier/package'

# Billing
module Cashier
  # Configure API
  class Configure
    attr_reader :packages
    attr_reader :subscriptions
    attr_writer :sms_price, :minute_price
    attr_writer :exchange_rate # value of 1 cents to our credit

    def subscription(name, price, opts = {})
      @subscriptions ||= {}
      @subscriptions[name.to_s] = Subscription.new(name, price * 100, opts)
    end

    def package(name, price, opts = {})
      @packages ||= {}
      @packages[name.to_s] = Package.new(name, price * 100, opts)
    end
  end
end
