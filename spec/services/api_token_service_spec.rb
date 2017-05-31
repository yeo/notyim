require "rails_helper"

RSpec.describe ApiTokenService, type: :service do
  let(:user) { FactoryGirl.create(:user) }

  describe '.retreive_for_user' do
    describe 'when already has token' do
      it 'returns the first one' do
        t = ApiToken.new(token: SecureRandom.hex)
        user.api_tokens << t
        token = described_class.retreive_for_user(user)
        expect(token.token).to eq(t.token)
      end
    end

    describe 'when has no token' do
      it 'auto creates and return that one' do
        token = described_class.retreive_for_user(user)
        expect(token).to be_kind_of(ApiToken)
        expect(token.token.split(".").first).to eq(user.id.to_s)
        expect(token.token.split(".").second.length).to eq(48)
      end
    end
  end
end
