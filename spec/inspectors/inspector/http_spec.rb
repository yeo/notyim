# frozen_string_literal: true

require 'rails_helper'
require 'inspector/http'

class I
  include Inspector::Http
end

RSpec.describe Inspector::Http, type: :inspector do
  let(:check) { double(Check, type: 'http') }
  let(:assertion) { double(Assertion, subject: 'http.status', condition: 'down') }
  let(:check_response) { double(CheckResponse, error: true) }

  subject { I.new }

  describe '#check_http' do
    before do
      allow(assertion).to receive(:check).and_return(check)
    end

    describe 'status assertion' do
      it 'returns true when match' do
        assertion = double(Assertion, subject: 'http.status', condition: 'down')
        check_response = double(CheckResponse, error: true, status: 'down')

        expect(subject.check_http(assertion, check_response)).to be(true)

        assertion = double(Assertion, subject: 'http.status', condition: 'up')
        check_response = double(CheckResponse, error: false, status: 'up')

        expect(subject.check_http(assertion, check_response)).to be(true)
      end

      it 'returns false when not match' do
        assertion = double(Assertion, subject: 'http.status', condition: 'down')
        check_response = double(CheckResponse, error: false, status: 'up')

        expect(subject.check_http(assertion, check_response)).to be(false)
      end
    end
  end

  describe 'response code assertion' do
    it 'return true when match' do
      assertion = double(Assertion, subject: 'http.code', condition: 'eq', operand: '200')
      check_response = double(CheckResponse, status_code: '200')

      expect(subject.check_http(assertion, check_response)).to be(true)
    end

    it 'return true when match' do
      assertion = double(Assertion, subject: 'http.code', condition: 'eq', operand: '200')
      check_response = double(CheckResponse, status_code: '301')

      expect(subject.check_http(assertion, check_response)).to be(false)
    end
  end
end
