require 'cashier/item'
module Cashier
  class Subscription < Item
    def description
      "subscription plan #{name}"
    end
  end
end
