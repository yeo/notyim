# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CheckInspector, type: :inspector do
  let(:check) { double(Check, type: 'http') }
  let(:assertion) { double(Assertion) }
  subject { described_class.new assertion }

  describe '#match?' do
    describe 'http check' do
      it 'invokes check_http' do
        allow(assertion).to receive(:check).and_return(check)
        expect(subject).to receive(:check_http).with(assertion, :foo)
        subject.match? :foo
      end
    end
  end
end
