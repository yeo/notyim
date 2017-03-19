module Api
  module Bot
    class RegistrationsController < BotController
      skip_before_action :require_bot_account

      def create
        user = User.find_by(email: params[:email]) rescue nil

        if user
          render json: {error: "Exist user"}, status: 422
        else
          # Create a bot user
          bot = ::Bot::RegistrationService.register(params[:email], params[:address])
          render json: {id: bot.user.id.to_s, token: bot.token}
        end
      end
    end
  end
end
