# frozen_string_literal: true

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
      # TODO: make sure user own this team
      team = Team.find(team)
      purchase = find_purchase(item['type'], item['id'])

      ChargeTransaction.create(
        amount: purchase.price,
        charge_type: item['type'],
        item: item['id'],
        event_source: charge,
        user: user,
        team: team
      )

      update_user_balance(user, purchase, item)
    end

    private

    def find_purchase(type, id)
      case type
      when 'package' then Cashier::Package.find(id)
      when 'subscription' then Cashier::Subscription.find(id)
      end
    end

    def update_user_balance(purchase, user, item)
      case purchase.type.downcase
      when 'package'
        add_user_balance(user, purchase.credit)
      when 'subscription'
        attach_subscription(team, user, item['id'])
      end

      # TODO: Email user about this
      user.save!
    end

    def add_user_balance(user, purchase)
      user.balance ||= 0
      user.balance += purchase.credit
    end

    def attach_subscription(team, user, plan_id)
      # TODO: better handle when user switch plan
      user.subscriptions << ::Subscription.new(
        start_at: Time.now,
        expire_at: 30.days.from_now,
        plan: plan_id,
        status: ::Subscription::STATUS_ACTIVED,
        team: team
      )
    end
  end
end
