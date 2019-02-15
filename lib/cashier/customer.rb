# frozen_string_literal: true

# Billing
module Cashier
  # Customer map
  class Customer
    attr_reader :user
    def initialize(user)
      @user = user
    end

    # Charge customer card and renew the plan
    def renew; end
  end
end
