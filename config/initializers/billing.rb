require 'cashier'

Cashier.configure do |config|
  config.sms_price  0.07
  config.minute_price 0.3

  config.plan :free, 0, {
    check: 50,
    sms: 0,
    minute: 0,
  }

  config.plan :premium, 10, {
    check: 100,
    sms: 200,
    minute: 10,
  }

  config.plan :awesome, 20, {
    check: 200,
    sms: 500,
    minute: 30,
  }

  config.package "150_000", 3
  config.package "300_000", 5
  config.package "600_000", 9
  config.package "10_000_000", 100
end
