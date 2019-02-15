# frozen_string_literal: true

# Billing
module Cashier
  # Item is a thing people paid for
  class Item
    attr_reader :name, :price, :opts

    def initialize(name, price, opts = {})
      @name = name
      @price = price
      @opts = opts
    end

    def self.find(id)
      config = ::Cashier.configure
      config.send(name.demodulize.pluralize.downcase).fetch(id)
    end

    # Type of item
    def type
      self.class.name.demodulize
    end
  end
end
