# frozen_string_literal: true

module Api
  module Bot
    class VerificationController < BotController
      skip_before_action :require_bot_account

      def link
        user = User.find(params[:user_id])
        @bot_account = BotAccount.find(params[:bot_id])

        return head(:forbidden) unless check_bot_verification_code

        @bot_account.user = user
        @bot_account.save!

        redirect_to root_path, notice: t('bot.success_link')
      end

      private

      def check_bot_verification_code
        params[:code] && @bot_account.link_verification_code == params[:code]
      end
    end
  end
end
