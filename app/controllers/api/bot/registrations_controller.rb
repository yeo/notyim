# frozen_string_literal: true

module Api
  module Bot
    class RegistrationsController < BotController
      skip_before_action :require_bot_account

      def create
        # TODO: handle right error DocumentNotFound
        @user = find_user_from_request

        return add_bot_to_user if @user

        # Create a bot user
        bot = ::Bot::RegistrationService.register(params[:email], params[:address])
        render json: { id: bot.user.id.to_s, token: bot.token }
      end

      private

      def add_bot_to_user
        bot = ::Bot::RegistrationService.add_bot_to_user(@user, params[:address])
        render json: bot
      rescue StandardError => e
        Raven.capture_exception(e)
        render json: { error: 'Exist user' }, status: 422
      end

      def find_user_from_request
        User.find_by(email: params[:email])
      rescue Mongoid::Errors::DocumentNotFound
        nil
      end
    end
  end
end
