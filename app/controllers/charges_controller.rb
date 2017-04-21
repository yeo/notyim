class ChargesController < DashboardController
  def new
  end

  def create
    begin
      @charge = ChargeService.purchase(current.user, current.team, OpenStruct.new(type: params[:tx_type], id: params[:item]), params[:stripeToken])
      redirect_to users_show_billings_path, notice: "Thanks you. We have charge an amount of #{@charge.amount / 100} on your card succesfully."
    rescue Stripe::CardError => e
      flash[:error] = e.message
      Bugsnag.notify(e)
      redirect_back fallback_location: user_show_billings_path
    rescue StandardError => e
      Bugsnag.notify(e)
      #redirect_to users_show_billings_path, error: "Fail to charge your card. We are notified this error and will contact with your shortly to fix this billing issue. Mean while, you may want to re-try with another card."
      redirect_to users_show_billings_path, notice: "Fail to charge your card. We are notified this error and will contact with your shortly to fix this billing issue. Mean while, you may want to re-try with another card."
    end
  end
end
