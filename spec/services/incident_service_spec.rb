require "rails_helper"

RSpec.describe IncidentService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  describe '.create_for_assertion' do
    it 'create open incident' do
      check = FactoryGirl.create(:http_check, user: user, team: user.team)

      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      check_result = :foo
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end
  end
end
