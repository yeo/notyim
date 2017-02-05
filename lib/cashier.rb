require 'cashier/configure'

module Cashier
  def self.configure
    @_config = Configure.new
    yield @_config
  end
end
