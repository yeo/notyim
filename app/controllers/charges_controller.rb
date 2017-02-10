class ChargesController < DashboardController
  def new
  end

  def create
    ChargeService.purchase(current.user, OpenStruct.new(type: params[:tx_type], id: params[:item]), params[:stripeToken])
    #ChargeService.create_customer(current.user, params)
  rescue Stripe::CardError => e
    flash[:error] = e.message
    redirect_back fallback_location: user_show_billings_path
  end
end
