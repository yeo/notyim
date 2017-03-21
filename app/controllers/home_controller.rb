class HomeController < ApplicationController
  def index
    @beta = true
    @botname = Rails.configuration.telegram_bot
  end
end
