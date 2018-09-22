require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { FactoryBot.create(:user) }

  describe '.create' do
    xit 'creates user with default team' do
    end
  end

  describe 'beta?' do
    it 'returns true for beta flag' do
      user.flags = {beta_tester: true}
      user.save!
      user.reload

      expect(user.beta?).to eq(true)
    end
  end
end
