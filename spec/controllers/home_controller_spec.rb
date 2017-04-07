require 'rails_helper'

RSpec.describe HomeController, type: :controller do
  let(:user) { FactoryGirl.create(:user) }

  #before do
  #OmniAuth.config.test_mode = true
  #request.env["devise.mapping"] = Devise.mappings[:user] # If using Devise
  #request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:github]
  #end

  describe 'GET #index' do
    describe 'not login' do
      it 'renders with login/register button' do
        get :index

        expect(response).to render_template(:index)
        expect(response.body).to include("Register")
        expect(response.body).to include("Login")
      end
    end

    describe 'signed in' do
      it 'renders with dashboard button' do
        sign_in user
        get :index

        expect(response).to render_template(:index)
        expect(response.body).to include("Go to dashboard")
      end
    end
  end
end
