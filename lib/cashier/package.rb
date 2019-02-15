# frozen_string_literal: true

require 'cashier/item'
module Cashier
  class Package < Item
    def description
      "package #{name}"
    end

    # Package use credit as its name for its simplicity
    def credit
      name.to_i
    end
  end
end
