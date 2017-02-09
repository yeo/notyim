class ChargesController < DashboardController
  def new
  end

  def create
    ChargeService.charge!(current.user, params[:stripeToken], OpenStruct(type: params[:type], id: params[:item]))
    #ChargeService.create_customer(current.user, params)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_back fallback_location: user_show_billings_path
  end
end
