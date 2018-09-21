require "rails_helper"

RSpec.describe IncidentService, type: :service do
  let(:check) { gen_check_and_assertion }
  let(:user) { incident.user }
  let(:check_result) { FactoryBot.build(:check_response) }

  describe '.create_for_assertion' do
    it 'create open incident' do
      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end

    it 'create partial incident' do
      Rails.configuration.incident_confirm_location = 2
      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      described_class.create_for_assertion(assertion, check_result)
      incident = Incident.desc(:id).first
      expect(incident.assertion).to eq(assertion)
    end
  end

  describe '.notify' do
    let(:incident) { FactoryBot.create(:incident, check: check, team: check.team, user: check.user, assertion: check.assertions.first) }

    it 'sends notification to user email when has no receiver' do
      receiver = double(Receiver)
      allow(Receiver).to receive(:new).and_return(receiver)
      service = double

      n = class_double(NotifyReceiverService)
      expect(n).to receive(:execute).with(incident, receiver)
      #allow(NotifyReceiverService).to receive(:new).with(incident, receiver).and_return(service)
      #expect(service).to receive(:execute)
      described_class.notify(incident, 'open')
    end

    it 'sends notification to receivers list' do

    end
  end
end
