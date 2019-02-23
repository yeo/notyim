# frozen_string_literal: true

require 'trinity/current'

module HomeHelper
  SLACK_OAUTH_URL = "https://slack.com/oauth/authorize"

  def new_slack_url
    if (current = Trinity::Current.current) && current.signed_in?
      "#{SLACK_OAUTH_URL}?state=#{current.user.id}.#{current.team.id}.#{SecureRandom.hex}&client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    else
      "#{SLACK_OAUTH_URL}?client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot&state=notydev&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
    end
  end

  def new_telegram_url
    if (current = Trinity::Current.current) && current.signed_in?
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}?start=#{SecureRandom.hex}"
    else
      "https://telegram.me/#{Rails.configuration.telegram_bot[:name]}"
    end
  end

  def slack_unauth_url
    "#{SLACK_OAUTH_URL}?client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=#{scope}&state=notydev&redirect_uri=#{Rails.configuration.slack_bot[:redirect_uri]}"
  end

  def slack_scope
    "bot,incoming-webhook,chat:write:bot"
  end
end
