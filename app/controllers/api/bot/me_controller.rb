module Api
  module Bot
    class MeController < BotController
      skip_before_action :require_bot_account

      def show
        token = params[:token] || request.headers['HTTP_X_BOT_TOKEN']

        if bot = BotAccount.find_by(token: token)
          if bot.user
            render json: {id: bot.user.id.to_s}
          else
            render json: {message: 'pending linking'}
          end
        else
          head :forbidden
        end
      end
    end
  end
end
