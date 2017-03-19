module Api
  module Bot
    class VerificationController < BotController
      skip_before_action :require_bot_account

      def link
        user = User.find(params[:user_id])
        bot_account = BotAccount.find(params[:bot_id])
        if params[:code] && bot_account.link_verification_code == params[:code]
          bot_account.user = user
          bot_account.save!

          redirect_to root_path, notice: "You have succesfully link the bot account and your noty.im account. Thank you"
        else
          head :forbidden
          # Using head to save us some request. this means something is wrong anyway
          #redirect_to root_path, flash: {error: "Invalid code"}
        end
      end
    end
  end
end
