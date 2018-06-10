require 'rails_helper'

RSpec.describe Api::Bot::RegistrationsController, type: :controller do
  describe '#create' do
    describe 'when email is new' do
      it 'create user with associated bot' do
        payload = {
          email: 'v@noty.im',
          address: {
            'channelId' => 'foo',
            'user' => 'user',
          }
        }

        post :create, params: payload, format: :json
        expect(User.desc(:id).first.email).to eq('v@noty.im')
        expect(User.desc(:id).first.bot_accounts.first.address).to eq(payload[:address])
      end
    end

    describe 'when email is already register' do
      it 'return 422' do
        u = User.new(email: 'foo@bar.com', password: '123456677', confirmed_at: Time.now.utc)
        #u.skip_confirmation_notification!
        #u.skip_confirmation!
        u.save!
        payload = {
          email: u.email,
          address: {
            channelId: 'foo',
            user: 'user',
          }
        }

        post :create, params: payload, format: :json
        expect(User.count).to eq(1)
      end
    end
  end
end
