# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Dashboard', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /dashboard' do
    include_examples 'require authenticated user', '/dashboard'

    it 'render checks/index' do
      sign_in user
      get '/dashboard'

      expect(response).to have_http_status(200)
      expect(response.body).to include('Create New Check')
    end
  end
end
