require 'trinity/current'

module HomeHelper
  def new_slack_url
    if user = Trinity::Current.current.try(:user)
      "https://slack.com/oauth/authorize?state=#{user.id.to_s}.#{SecureRandom.hex}&client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    else
      "https://slack.com/oauth/authorize?client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&state=notydev&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    end
  end
end
