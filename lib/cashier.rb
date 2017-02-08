require 'cashier/configure'

module Cashier
  def self.configure
    @_config ||= Configure.new
    yield @_config if block_given?

    @_config
  end
end
