module Api
  module Bot
    class RegistrationsController < BotController
      skip_before_action :require_bot_account

      def create
        # TODO: handle right error DocumentNotFound
        user = User.find_by(email: params[:email]) rescue nil

        if user
          begin
            bot = ::Bot::RegistrationService.add_bot_to_user(user, params[:address])
            render json: bot
          rescue => e
            Bugsnag.notify e
            render json: {error: "Exist user"}, status: 422
          end
        else
          # Create a bot user
          bot = ::Bot::RegistrationService.register(params[:email], params[:address])
          render json: {id: bot.user.id.to_s, token: bot.token}
        end
      end
    end
  end
end
