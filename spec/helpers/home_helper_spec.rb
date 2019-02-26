# frozen_string_literal: true

require 'rails_helper'

RSpec.describe HomeHelper, type: :helper do
  let(:user) { FactoryBot.create(:user) }

  describe '#new_slack_url' do
    describe 'anonymous user' do
      it 'returns slack url' do
        expect(helper.new_slack_url).to eq('https://slack.com/oauth/authorize?state=anonymous&client_id=134&scope=bot,incoming-webhook,chat:write:bot&redirect_uri=http://127.0.0.1:3000/bot/slack')
      end
    end

    describe 'login' do
      it 'returns slack url' do
        Trinity::Current.instance(user, Struct.new(:host, :domain).new('foo', 'foo'), Hash.new)
        allow(SecureRandom).to receive(:hex) { "100" }

        url = %(
          https://slack.com/oauth/authorize?state=#{user.id.to_s}.#{user.default_team.id.to_s}.100
          &client_id=134&
          scope=bot,incoming-webhook,chat:write:bot&redirect_uri=http://127.0.0.1:3000/bot/slack
        ).gsub(/[\n\s]/, '')

        expect(helper.new_slack_url).to eq(url)
      end
    end
  end
end
