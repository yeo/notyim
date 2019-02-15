# frozen_string_literal: true

module Api
  module Bot
    class MeController < BotController
      skip_before_action :require_bot_account

      def show
        token = params[:token] || request.headers['HTTP_X_BOT_TOKEN']
        bot = BotAccount.find_by(token: token)

        return head(:forbidden) unless bot

        if bot.user
          render json: { id: bot.user.id.to_s }
        else
          render json: { message: 'pending linking' }
        end
      end
    end
  end
end
