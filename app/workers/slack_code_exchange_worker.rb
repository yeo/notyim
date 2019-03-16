# frozen_string_literal: true

require 'net/http'

class SlackCodeExchangeWorker
  include Sidekiq::Worker
  # sidekiq_options(retry: 5)

  # @param sting check id
  # @param Hash result
  #         - total_time
  #         - body
  #         - total_size
  #         - response_code
  def perform(code, state)
    ReceiverService.save(create_receiver(code, state))

    Yeller::Provider::SlackBot.notify_welcome(receiver)
  end

  private

  def creat_receiver(code, state)
    user_id, team_id, token = state.split('.')
    puts "code #{code} state #{state} token #{token}"
    # TODO: should we really want to validate token? It's a random unused value for now
    user = User.find user_id
    team = Team.find team_id
    # TODO: check if team belongs to this user

    payload = post_to_slack(code)
    receiver = Receiver.new(
      provider: 'SlackBot',
      name: payload['team_name'],
      handler: payload['team_id'],
      provider_params: payload,
      user: user,
      team: team
    )
    receiver.provider_attributes(payload)
  end

  def post_to_slack
    uri = URI('https://slack.com/api/oauth.access')
    slack = Rails.configuration.slack_bot
    res = Net::HTTP.post_form(uri,
                              client_id: slack[:client_id],
                              client_secret: slack[:client_secret],
                              code: code,
                              redirect_uri: slack[:redirect_uri])
    payload = JSON.parse res.body

    payload
  end
end
