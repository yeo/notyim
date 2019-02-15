# frozen_string_literal: true

require 'cashier/item'

# Billing
module Cashier
  # Subscription is a thing people paid with a reccuring payment
  class Subscription < Item
    def description
      "subscription plan #{name}"
    end
  end
end
