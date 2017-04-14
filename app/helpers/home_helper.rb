require 'trinity/current'

module HomeHelper
  def new_slack_url
    if (current = Trinity::Current.current) && current.signed_in?
      "https://slack.com/oauth/authorize?state=#{current.user.id.to_s}.#{current.team.id.to_s}.#{SecureRandom.hex}&client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    else
      "https://slack.com/oauth/authorize?client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&state=notydev&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    end
  end

  def new_telegram_url
    if (current = Trinity::Current.current) && current.signed_in?
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}?start=#{SecureRandom.hex}"
    else
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}"
    end
  end
end
