# frozen_string_literal: true

require 'trinity'

class ChargeService
  def self.purchase(user, team, item, stripe_token = nil)
    customer = get_or_create_token(user, stripe_token)
    raise 'Missing stripe token' unless customer

    charge = charge!(customer, purchase_from_item(item))
    Cashier::PurchaseSuccessWorker.perform_async(
      user.id.to_s,
      team.id.to_s,
      { type: item.type, id: item.id },
      charge.to_hash
    )

    charge
  end

  def self.purchase_from_item(item)
    purchase = case item.type
               when 'package' then Cashier::Package.find(item.id)
               when 'subscription' then Cashier::Subscription.find(item.id)
               end

    raise 'Purchase not found' unless purchase

    purchase
  end

  # Charge given token
  # @param User|StripeToken model
  #         in case of user, we will charge the lastest linked card
  # @param Object purchase has to include
  #        - price amount in cent
  #        - description
  def self.charge!(token, purchase)
    case token
    when User
      token = user.stripe_tokens.desc(:id).first
    end

    charge = Stripe::Charge.create(
      customer: token.customer,
      amount: purchase.price,
      description: "https://noty.im #{purchase.description}",
      currency: 'usd'
    )
    charge
  end

  def self.get_or_create_token(user, stripe_token)
    if stripe_token
      create_customer(user, stripe_token)
    else
      user.stripe_tokens.latest
    end
  end

  # @param User user model
  # @param String stripe token
  def self.create_customer(user, stripe_token)
    customer = Stripe::Customer.create(
      email: user.email,
      source: stripe_token
    )

    # The token is single-time used only but we store it for reference/debug purpose
    (user.stripe_tokens << StripeToken.new(
      token: stripe_token,
      customer: customer.id
    )).last
  end

  def self.charge_user
    Stripe::Charge.create(
      customer: customer.id,
      amount: @amount,
      description: 'NotyIM customer',
      currency: 'usd'
    )
  end

  # Charge user moeny and set expired day
  def self.charge_user_for_plan(user, plan); end
end
