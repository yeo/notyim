# frozen_string_literal: true

require 'rails_helper'
require 'mongoid/verifiable'

class Foo
  include Mongoid::Document
  include Mongoid::Verifiable
end

RSpec.describe Mongoid::Verifiable do
  let(:model) { Foo.new }

  it 'includes in model' do
    expect(model).to be_a(Foo)
  end

  describe '#verify!' do
    it 'set attb' do
      model.verify!

      expect(model.persisted?).to eq(true)
      expect(model.verified).to eq(true)
    end

    it 'has many verifications' do
      model.verifications << Verification.new(code: '1234')
      expect(model.verifications.length).to eq(1)
      model.verifications << Verification.new(code: '1234a')
      expect(model.verifications.length).to eq(2)
    end
  end
end
