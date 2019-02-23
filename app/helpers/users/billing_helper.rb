# frozen_string_literal: true

module Users
  module BillingHelper
    def active_subscriptions
      config = ::Cashier.configure
      config.subscriptions
    end

    def active_packages
      config = ::Cashier.configure
      config.packages
    end
  end
end
