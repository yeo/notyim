class ApiTokenService
  def self.retreive_for_user(user)
    if (token = user.api_tokens.desc(:id).first).present?
      return token
    end

    t = user.id.to_s
    t << '.'
    t << Devise.friendly_token(48)
    user.api_tokens << ApiToken.new(token: t)
    user.api_tokens.desc(:id).first
  end
end
