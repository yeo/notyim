# frozen_string_literal: true

class ApiTokenService
  def self.retreive_for_user(user)
    return user.api_tokens.desc(:id).first if user.api_tokens.count.positive?

    create_api_token_for_user(user)
  end

  def self.create_api_token_for_user(user)
    token = user.id.to_s
    token << '.'
    token << Devise.friendly_token(48)

    user.api_tokens << ApiToken.new(token: t)

    user.api_tokens.desc(:id).first
  end
end
