module Bot
  class SlackController < ApplicationController
    def create
      puts params
      code  = params[:code]
      state = params[:state]
      SlackCodeExchangeWorker.perform_async(code, state)
    end
  end
end
