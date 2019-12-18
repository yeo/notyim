# frozen_string_literal: true

class ChargesController < DashboardController
  def new; end

  def create
    charge!
    redirect_to users_show_billings_path, notice: t('payment.success_charge', amount: @charge.amount / 100)
  rescue Stripe::CardError => e
    stripe_card_error e
  rescue StandardError => e
    generic_charge_error e
  end

  private

  def charge!
    @item = OpenStruct.new(type: params[:tx_type], id: params[:item]), params[:stripeToken]
    @charge = ChargeService.purchase(current.user, current.team, item)
  end

  def stripe_card_error(err)
    flash[:error] = err.message
    Raven.capture_exception(err, extra: { user: current.user.id.to_s, email: current.user.email })

    redirect_back fallback_location: user_show_billings_path, alert: t('payment.card_error')
  end

  def generic_charge_error(err)
    Raven.capture_exception(err, extra: { user: current.user.id.to_s, email: current.user.email })

    redirect_to users_show_billings_path, notice: t('payment.fail_charge')
  end
end
