class ChargesController < DashboardController
  def new
  end

  def create
    # Amount in cents
    @amount = (9.99 * 100).to_i
    ChargeService.create_customer(current.user, params)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_to new_charge_path
  end
end
