# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Home', type: :request do
  let(:user) { FactoryBot.create(:user) }

  # before do
  # OmniAuth.config.test_mode = true
  # request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
  # request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  # end

  describe 'GET #index' do
    describe 'not login' do
      it 'renders with login/register button' do
        get root_path

        expect(response.body).to include('Register')
        expect(response.body).to include('Login')
      end
    end

    describe 'signed in' do
      it 'renders with dashboard button' do
        sign_in user
        get root_path

        expect(response).to have_http_status(200)
        expect(response.body).to include('Go to dashboard')
      end
    end

    describe 'domain is status page' do
      xit 'renders check/show' do
      end
    end
  end
end
