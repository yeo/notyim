module Bot
  def self.uuid(address)
    [address['channelId'], address['user']['id']].join("_")
  end

  class RegistrationService
    # Register a new user and bot at a same time
    def self.register(email, address)
      # TODO Add more validation since this is a two phase transaction
      p = SecureRandom.hex
      user = User.new(
        email: email,
        password: p,
        password_confirmation: p,
        confirmed_at: Time.now.utc, # skip confirmation)
      )
      user.skip_confirmation!
      user.skip_confirmation_notification!
      user.save!
      begin
        if bot = BotAccount.where(bot_uuid: ::Bot.uuid(address)).first
          bot.address = address
          bot.user = user
          bot.save!
        else
          bot = BotAccount.create!(
            bot_uuid: ::Bot.uuid(address),
            address: address.permit(:channelId, :user).to_hash,
            user: user,
            team: user.teams.first.id)
        end
        bot
      rescue
        user.destroy.yield_self { nil }
      end
    end

    # Register bot account to an *existing* user
    def self.add_bot_to_user(user, address)
      if user.is_a?(String) && user.include?("@")
        user = User.find_by(email: user)
      end

      if bot = BotAccount.where(bot_uuid: ::Bot.uuid(address)).first
        bot.link_verification_code = SecureRandom.hex
        bot.address = address
        bot.save!
      else
        bot = BotAccount.create!(
          bot_uuid: ::Bot.uuid(address),
          address: address,
          link_verification_code: SecureRandom.hex
        )
      end
      # Send an email to confirm
      BotAccountMailer.verify_link_account(user.id.to_s, bot.id.to_s).deliver_later

      bot
    end
  end
end
