class ChargesController < DashboardController
  def new

  end

  def create
    # Amount in cents
    @amount = (9.99 * 100).to_i

    customer = Stripe::Customer.create(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken]
    )

    current.user.stripe_tokens << StripeToken.new(
      :email => params[:stripeEmail],
      :source  => params[:stripeToken],
      :customer => customer.id
    )

    charge = Stripe::Charge.create(
      :customer    => customer.id,
      :amount      => @amount,
      :description => 'NotyIM customer',
      :currency    => 'usd'
    )

  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
