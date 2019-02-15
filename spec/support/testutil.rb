# frozen_string_literal: true

module TestUtils
  module Request
    def reset_request_store
      RequestStore.store[:current_request] = nil
    end
  end

  module GenData
    def gen_check_and_assertion
      user = FactoryBot.create(:user)
      check = FactoryBot.create(:check, user: user, team: user.teams.first)
      assertion = FactoryBot.create(:assertion, check: check)

      check
    end

    def gen_incident
      user = FactoryBot.create(:user)
      check = FactoryBot.create(:check, user: user, team: user.teams.first)
      assertion = FactoryBot.create(:assertion, check: check)
      incident = FactoryBot.create(:incident, check: check, team: check.team, user: check.user, assertion: assertion)

      incident
    end
  end
end

RSpec.configure do |config|
  config.include TestUtils::GenData
  config.include TestUtils::Request
end
