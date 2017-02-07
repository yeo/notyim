class ChargeService
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
end
