# frozen_string_literal: true

module Bot
  class SlackController < ApplicationController
    def create
      code  = params[:code]
      state = params[:state]
      SlackCodeExchangeWorker.perform_async(code, state)

      redirect_to receivers_path, notice: 'Thank you. You have succesfully connect to noty chat bot' if user_signed_in?
    end
  end
end
