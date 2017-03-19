module Bot
  class RegistrationService
    # Register a new user and bot at a same time
    def self.register(email, address)
      # TODO Add more validation since this is a two phase transaction
      user = User.new(
        email: email,
        password: SecureRandom.hex,
      )
      user.skip_confirmation!
      user.save!
      begin
        bot = BotAccount.create!(address: address, user: user)
        bot
      rescue
        user.destroy
        nil
      end
    end

    # Register bot account to an *existing* user
    def self.add_bot_to_user(user, address)
      if user.is_a?(String) && user.include?("@")
        user = User.find_by(email: user)
      end

      bot = BotAccount.create!(address: address, link_verification_code: SecureRandom.hex)
      # Send an email to confirm
      BotAccountMailer.verify_link_account(user.id.to_s, bot.id.to_s).deliver_later

      bot
    end
  end
end
