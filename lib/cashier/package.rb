# frozen_string_literal: true

require 'cashier/item'

# Billing
module Cashier
  # Syntatix suger for item with some method
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
