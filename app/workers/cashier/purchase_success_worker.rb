module Cashier
  # Logic handler after charging user succesfully
  class PurchaseSuccessWorker
    include Sidekiq::Worker


    # Charge card
    #   -> Create subscription
    #   -> Create credit
    #
    # Find user who run out of credit and email them to buy
    # or select a new plan
    def perform(uid, team, item, charge)
      user = User.find(uid)
      # TODO make sure user own this team 
      team = Team.find team


      purchase = case item["type"]
               when 'package' then Cashier::Package.find(item["id"])
               when 'subscription' then Cashier::Subscription.find(item["id"])
               end

      ChargeTransaction.create(
        amount: purchase.price,
        charge_type: item["type"],
        item: item["id"],
        event_source: charge,
        user: user,
        team: team,
      )

      case purchase.type.downcase
      when 'package'
        user.balance ||= 0
        user.balance += purchase.credit
      when 'subscription'
        # TODO better handle when user switch plan
        user.subscriptions << ::Subscription.new(
          start_at: Time.now,
          expire_at: 30.days.from_now,
          plan: item["id"],
          status: ::Subscription::STATUS_ACTIVED,
          team: team,
        )
      end

      # TODO Email user about this
      user.save!
    end
  end
end
