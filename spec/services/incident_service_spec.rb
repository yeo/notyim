require "rails_helper"

RSpec.describe IncidentService, type: :service do
  describe '.create_for_assertion' do
    it 'create open incident' do
      check = Check.create!(type: 'http')
      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      check_result = :foo
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end
  end
end
