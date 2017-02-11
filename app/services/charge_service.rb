class ChargeService
  def self.purchase(user, item, stripe_token=nil)
    customer = get_or_create_token(user, stripe_token)
    raise "Missing stripe token" unless customer

    purchase = case item.type
               when 'package' then Cashier::Package.find(item.id)
               when 'subscription' then Cashier::Subscription.find(item.id)
               end
    raise "Purchase not found" unless purchase

    charge = charge!(customer, purchase)
    ChargeTransaction.create(
      amount: purchase.price,
      charge_type: item.type,
      item: item.id,
      event_source: charge.to_hash,
      user: user
    )

    case purchase.type.downcase
    when 'package'
      user.credit += purchase.credit
    when 'subscription'
      user.active_subscription = purchase.name
      if user.subscription_expire_at < Time.now
        user.subscription_expire_at = 30.days.from.now
      else
        user.subscription_expire_at += 30.days
      end

      Subscription.create!(start_at: Time.now, expire_at: 30.days.from.now, user: user)
    end

    user.save!
    charge
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
      :email => user.email,
      :source  => stripe_token
    )

    # The token is single-time used only but we store it for reference/debug purpose
    (user.stripe_tokens << StripeToken.new(
      :token  => stripe_token,
      :customer => customer.id
    )).last
  end

  def self.charge_user
    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'NotyIM customer',
      :currency    => 'usd'
    )
  end
  # Charge user moeny and set expired day
  def self.charge_user_for_plan(user, plan)

  end
end
