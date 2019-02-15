# frozen_string_literal: true

require 'cashier/configure'

# Cashier is our billing logic
module Cashier
  def self.configure
    @_config ||= Configure.new
    yield @_config if block_given?

    @_config
  end
end
