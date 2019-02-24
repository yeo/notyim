# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Teams', type: :request do
  let(:user) { FactoryBot.create(:user) }

  describe 'GET /teams' do
    it 'shows current team' do
      sign_in user

      get teams_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(user.default_team.name)
    end

    xit 'lists all teams' do

    end
  end

end
