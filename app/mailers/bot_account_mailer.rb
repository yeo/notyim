class BotAccountMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  def verify_link_account(user, bot)
    @user = User.find(user)
    @bot = BotAccount.find(bot)
    @url = [api_bot_link_verification_url(@user.id.to_s, @bot.id.to_s), "?code=", @bot.link_verification_code].join('')
    mail(to: @user.email, subject: "noty.im bot account verification")
  end
end
