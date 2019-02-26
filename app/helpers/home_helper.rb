# frozen_string_literal: true

require 'trinity/current'

module HomeHelper
  SLACK_OAUTH_URL = 'https://slack.com/oauth/authorize'
  SLACK_CLIENT_ID = Rails.configuration.slack_bot[:client_id]
  SLACK_SCOPE     = 'bot,incoming-webhook,chat:write:bot'
  SLACK_REDIRECT_URI = Rails.configuration.slack_bot[:redirect_uri]

  def new_slack_url
    url = SLACK_OAUTH_URL

    state = if (current = Trinity::Current.current) && current.signed_in?
              "state=#{current.user.id}.#{current.team.id}.#{SecureRandom.hex}"
            else
              'state=anonymous'
            end

    url + "?#{state}&client_id=#{SLACK_CLIENT_ID}&scope=#{SLACK_SCOPE}&redirect_uri=#{SLACK_REDIRECT_URI}"
  end

  def new_telegram_url
    if (current = Trinity::Current.current) && current.signed_in?
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}?start=#{SecureRandom.hex}"
    else
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}"
    end
  end
end
