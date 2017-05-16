module TestUtils
  module GenData
    def gen_check_and_assertion
      user = FactoryGirl.create(:user)
      check = FactoryGirl.create(:http_check, user: user, team: user.teams.first)
      assertion = FactoryGirl.create(:assertion, check: check)

      check
    end

    def gen_
      user = FactoryGirl.create(:user)
      check = FactoryGirl.create(:http_check, user: user, team: user.teams.first)
      assertion = FactoryGirl.create(:assertion, check: check)
      incident = FactoryGirl.create(:incident, check: check, team: check.team, user: check.user, assertion: assertion)

      incident
    end

  end
end

RSpec.configure do |config|
  config.include TestUtils::GenData
end
