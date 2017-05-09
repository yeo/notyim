require "rails_helper"

RSpec.describe IncidentService, type: :service do
  let(:user) { FactoryGirl.create(:user) }
  let(:check_result) { FactoryGirl.build(:check_response) }

  describe '.create_for_assertion' do
    it 'create open incident' do
      check = FactoryGirl.create(:http_check, user: user, team: user.teams.first)
      assertion = Assertion.create!(subject: 'http.status', condition: 'down', check: check)
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end
  end

  describe '.notify' do
    let(:incident) { FactoryGirl.create(:incident) }
    let(:user) { incident.user }

    it 'sends notification to user when has no receiver' do
      receiver = double(Receiver)
      allow(Receiver).to receive(:new).and_return(receiver)
      allow(NotifyReceiverService).to receive(:new).with(incident, receiver).and_return(service)
      expect(service).to receive(:execute)
      described_class.notify(incident, 'open')
    end

    it 'sends notification to receivers list' do

    end
  end
end
