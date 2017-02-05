module Cashier
  class Plan
    attr_reader :name, :price, :opts
    def initialize(name, price, opts = {})
      @name = name
      @price = price
      @opts = opts
    end
  end
end
