module Cashier
  class RenewSubscriptionWorker
    include Sidekiq::Worker

    # Find user with existing plan and attemt to renew
    def perform
      User.where(:plan_expire_at.gt => Time.now).pluck(:id).each do |uid|
        customer = Cashier::Customer.new(uid)
        customer.renew
      end
    end
  end
end
