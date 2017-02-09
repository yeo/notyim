class ChargeService
  def self.charge!(user, item, stripe_token=nil)
    customer = if stripe_token
                 create_customer(user, stripe_token)
               else
                 user.stripe_tokens.latest
               end
    raise "Missing stripe token" unless customer

    case item
    when Float
      charge = Stripe::Charge.create(
        :customer    => customer.customer,
        :amount      => item,
        :description => 'https://noty.im payment',
        :currency    => 'usd'
      )
    else
      purchase = case item.type
                 when 'package' then Cashier::Package.find(item.id)
                 when 'subscription' then Cashier::Subscription.find(item.id)
                 end
      raise "Purchase not found" unless purchase
      charge = Stripe::Charge.create(
        customer: customer.customer,
        amount: purchase.price,
        description: "https://noty.im #{purchase.description}",
        currency: 'usd'
      )
    end

    # TODO: Store into Transaction Log
    charge
  end

  # @param User user model
  # @param String stripe token
  def self.create_customer(user, stripe_token)
    customer = Stripe::Customer.create(
      :email => user.email,
      :source  => stripe_token
    )

    # The token is single-time used only but we store it for reference/debug purpose
    user.stripe_tokens << StripeToken.new(
      :token  => stripe_token,
      :customer => customer.id
    )
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
