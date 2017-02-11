module Users::BillingHelper
  def active_subscriptions
    config = ::Cashier.configure
    config.subscriptions
  end

  def active_packages
    config = ::Cashier.configure
    config.packages
  end
end
