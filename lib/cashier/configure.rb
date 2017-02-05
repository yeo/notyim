require 'cashier/plan'

module Cashier
  class Configure
    attr_reader :plans
    attr_reader :sms_price, :minute_price

    def sms_price(p)
      @sms_price = p
    end

    def minute_price(p)
      @minute_price = p
    end

    def plan(name, price, opts = {})
      @plans ||= {}
      @plans << Plan.new(name, price, opts)
    end
  end
end
