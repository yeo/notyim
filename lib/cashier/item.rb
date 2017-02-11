module Cashier
  class Item
    attr_reader :name, :price, :opts

    def initialize(name, price, opts = {})
      @name = name
      @price = price
      @opts = opts
    end

    def self.find(id)
      config = ::Cashier.configure
      config.send(self.name.demodulize.pluralize.downcase).fetch(id)
    end

    # Type of item
    def type
      self.class.name.demodulize
    end
  end
end
