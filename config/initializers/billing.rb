# frozen_string_literal: true

require 'cashier'

Cashier.configure do |config|
  # We use cents for all currency unit
  config.exchange_rate = 1000 # 1 cent -> 1000 credit

  config.sms_price = 0.07 * 100 / 1000
  config.minute_price = 0.3

  config.subscription :trial, 0,
                      check: 1,
                      sms: 0,
                      minute: 0,
                      region: 2,
                      team: false,
                      status_page: true,
                      custom_domain_ssl: false

  config.subscription :starter, 3,
                      check: 3,
                      sms: 10,
                      minute: 5,
                      region: 5,
                      team: true,
                      status_page: true,
                      custom_domain_ssl: true

  config.subscription :premium, 10,
                      check: 100,
                      sms: 200,
                      minute: 10,
                      region: 5,
                      team: true,
                      status_page: true,
                      custom_domain_ssl: true

  config.subscription :awesome, 20,
                      check: 200,
                      sms: 500,
                      minute: 30,
                      region: 5,
                      team: true,
                      status_page: true,
                      custom_domain_ssl: true

  config.package '150_000', 3
  config.package '300_000', 5
  config.package '600_000', 9
  config.package '10_000_000', 100
end
