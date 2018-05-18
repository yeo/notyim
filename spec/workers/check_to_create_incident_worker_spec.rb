require 'rails_helper'
RSpec.describe CheckToCreateIncidentWorker, type: :worker do
  let(:check) { double(Check, id: 12, type: 'http') }
  let(:check_response) {
    double(CheckResponse,
           status: 'down',
           raw_result: :foo,
           error: true,
           body: 'ok',
           time: 100000 )
  }

  before do
    allow(Check).to receive(:find).with(check.id).and_return(check)
    allow(CheckResponse).to receive(:create_from_raw_result).with(check_response.raw_result).and_return(check_response)
  end

  subject { described_class.new }

  describe '#perform' do
    describe 'match assetion' do
      xit 'create an incident' do

      end
    end

    describe 'not match any assertion' do
      xit 'close an incident' do
      end
    end
    #describe 'check has at least an assertion matches check response' do
    #  it 'create incident' do
    #    assertions = [
    #      double(Assertion, subject: 'http.status', condition: 'eq', operand: 'down', check: check),
    #      double(Assertion, subject: 'http.body', condition: 'contain', operand: 'heavy load', check: check),
    #      double(Assertion, subject: 'http.response_time', condition: 'gt', operand: '9000', check: check),
    #    ]
    #    allow(check).to receive(:assertions).and_return assertions

    #    expect(IncidentService).to receive(:create_for_assertion).with(assertions.last, check_response)
    #    expect(IncidentService).to receive(:create_for_assertion).with(assertions.first, check_response)
    #    subject.perform(check.id, check_response.raw_result)
    #  end
    #end

    #describe 'check has no assertion matches check response' do
    #  it 'does nothing' do
    #    assertions = [
    #      double(Assertion, subject: 'http.body', condition: 'contain', operand: 'heavy load', check: check),
    #    ]
    #    allow(check).to receive(:assertions).and_return assertions
    #    expect(IncidentService).to_not receive(:create_for_assertion).with(anything, anything)
    #    subject.perform(check.id, check_response.raw_result)
    #  end
    #end
  end
end
