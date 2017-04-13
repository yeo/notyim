module HomeHelper
  def new_slack_url
    "https://slack.com/oauth/authorize?&client_id=#{Rails.configuration.slack_bot[:client_id]}&scope=bot,incoming-webhook,chat:write:bot"
  end
end
