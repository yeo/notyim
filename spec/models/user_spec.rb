require 'rails_helper'

RSpec.describe User, type: :model do
  describe '.create' do
    it 'creates user with default team' do
      user = User.create!(
        email: 'foo@bar.com',
        password: '123456',
      )

      expect(user.credit).to eq(0)
      expect(user.teams.first.name).to eq('My team')
    end
  end
end
