# frozen_string_literal: true

module Bot
  def self.uuid(address)
    [address['channelId'], address['user']['id']].join('_')
  end

  class RegistrationService
    # Register a new user and bot at a same time
    def self.register(email, address)
      # TODO: Add more validation since this is a two phase transaction
      # TODO: Use transaction in 4.0
      user = create_user(email)

      if (bot = BotAccount.where(bot_uuid: ::Bot.uuid(address)).first)
        link_bot_to_user(bot, user)

        return bot
      end

      BotAccount.create!(
        bot_uuid: ::Bot.uuid(address),
        address: address.permit(:channelId, :user).to_hash,
        user: user,
        team: user.teams.first.id
      )
    rescue StandardError
      user.destroy.then { nil }
    end

    def self.find_or_create_bot_from_address
      bot = BotAccount.where(bot_uuid: ::Bot.uuid(address)).first
      unless bot
        return BotAccount.create!(
          bot_uuid: ::Bot.uuid(address),
          address: address,
          link_verification_code: SecureRandom.hex
        )
      end

      bot.tap do
        bot.link_verification_code = SecureRandom.hex
        bot.address = address
        bot.save!
      end
    end

    # Register bot account to an *existing* user
    def self.add_bot_to_user(user, address)
      user = User.find_by(email: user) if user.is_a?(String) && user.include?('@')

      bot = find_or_create_bot_from_address(address)

      # Send an email to confirm
      BotAccountMailer.verify_link_account(user.id.to_s, bot.id.to_s).deliver_later

      bot
    end

    def self.link_bot_to_user(bot, user)
      bot.address = address
      bot.user = user
      bot.save!
    end

    def self.create_user(email)
      password = SecureRandom.hex
      user = User.new(
        email: email,
        password: password,
        password_confirmation: password,
        confirmed_at: Time.now.utc # skip confirmation)
      )
      user.skip_confirmation!
      user.skip_confirmation_notification!
      user.save!

      user
    end
  end
end
