module Cashier
  class Subscription
    attr_reader :name, :price, :opts
    def initialize(name, price, opts = {})
      @name = name
      @price = price
      @opts = opts
    end
  end
end
