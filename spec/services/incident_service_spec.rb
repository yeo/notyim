# frozen_string_literal: true

require 'rails_helper'

RSpec.describe IncidentService, type: :service do
  let(:check) { gen_check_and_assertion }
  let(:user) { incident.user }
  let(:check_result) { FactoryBot.build(:check_response) }

  let(:http_down) do
    Assertion.create!(subject: 'http.status', condition: 'down', check: check)
  end

  describe '.create_for_assertion' do
    it 'create open incident' do
      assertion = http_down
      described_class.create_for_assertion(assertion, check_result)
      expect(Incident.desc(:id).first.assertion).to eq(assertion)
    end

    it 'create partial incident' do
      Rails.configuration.incident_confirm_location = 2
      assertion = http_down
      described_class.create_for_assertion(assertion, check_result)
      incident = Incident.desc(:id).first
      expect(incident.assertion).to eq(assertion)
    end
  end

  describe '.notify' do
    let(:incident) do
      FactoryBot.create(:incident,
                        check: check,
                        team: check.team,
                        user: check.user,
                        assertion: check.assertions.first)
    end

    it 'sends notification to user email when has no receiver' do
      receiver = double(Receiver)
      allow(Receiver).to receive(:new).with(provider: 'Email',
                                            name: incident.check.user.email,
                                            handler: incident.check.user.email,
                                            require_verify: false, verified: true)
                                      .and_return(receiver)

      expect(NotifyReceiverService).to receive(:execute).with(incident, receiver)
      described_class.notify(incident, 'open')
    end

    it 'sends notification to receivers list' do
      # if (receivers = incident.check.fetch_receivers).present?
      receivers = Array.new(3, double(Receiver))
      allow(incident.check).to receive(:fetch_receivers).and_return(receivers)

      receivers.each do |receiver|
        expect(NotifyReceiverService).to receive(:execute).with(incident, receiver)
      end
      described_class.notify(incident, 'open')
    end
  end
end
