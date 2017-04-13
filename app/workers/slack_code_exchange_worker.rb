require 'net/http'

class SlackCodeExchangeWorker
  include Sidekiq::Worker
  #sidekiq_options(retry: 5)


  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(code, state)
    puts "code #{code} state #{state}"
    user_id, token = state.split('.')
    # TODO: should we really want to validate token? It's a random unused value for now
    user = User.find user_id

    uri = URI('https://slack.com/api/oauth.access')
    slack = Rails.configuration.slack_bot
    res = Net::HTTP.post_form(uri, client_id: slack[:client_id], client_secret: slack[:client_secret], code: code, redirect_uri: slack[:redirect_uri])
    payload = JSON.parse res.body
    puts payload

    user.bot_accounts << BotAccount.create!(
      bot_uuid: "slack_#{payload["bot"]["bot_user_id"]}",
      token: payload["access_token"],
      address: {channelId: "slack", team_id: payload["team_id"], user_id: payload["user_id"]},
      meta: payload,
    )
  end
end
