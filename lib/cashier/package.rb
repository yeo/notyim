require 'cashier/item'
module Cashier
  class Package < Item
    def description
      "package #{name}"
    end
  end
end
