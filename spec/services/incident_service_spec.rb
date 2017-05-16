require "rails_helper"

RSpec.describe IncidentService, type: :service do
  let(:check) { gen_check_and_assertion }
  let(:user) { incident.user }
  let(:check_result) { FactoryGirl.build(:check_response) }

  describe '.create_for_assertion' do
    it 'create open incident' do
      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end
  end

  describe '.notify' do
    let(:incident) { FactoryGirl.create(:incident, check: check, team: check.team, user: check.user, assertion: check.assertions.first) }

    it 'sends notification to user when has no receiver' do
      receiver = double(Receiver)
      service = double
      allow(Receiver).to receive(:new).and_return(receiver)
      allow(NotifyReceiverService).to receive(:new).with(incident, receiver).and_return(service)
      expect(service).to receive(:execute)
      described_class.notify(incident, 'open')
    end

    it 'sends notification to receivers list' do

    end
  end
end
