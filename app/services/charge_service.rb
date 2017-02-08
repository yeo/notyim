class ChargeService
  def self.charge(user, tx_type, item)

  end

  def self.create_customer(user, params)
    user.stripe_tokens << StripeToken.new(
      :source  => params[:stripeToken],
      :email => params[:stripeEmail],
      :customer => customer.id
    )

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

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
