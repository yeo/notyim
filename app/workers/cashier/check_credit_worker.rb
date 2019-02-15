# frozen_string_literal: true

module Cashier
  class CheckCreditWorker
    include Sidekiq::Worker

    # Find user who run out of credit and email them to buy
    # or select a new plan
    def perform
      Users.where(:used_credit.gt => :credit).pluck(:id).to_a do |_uid|
        # If user enable auto refill then charge the card
        customer = Cashier::Reminder.remind_credit_purchase
        customer.renew
      end
    end
  end
end
