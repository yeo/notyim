# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Checks', type: :request do
  let(:uri) { 'https://foo.com' }
  let(:user) { FactoryBot.create(:user) }
  let(:user2) { FactoryBot.create(:user) }
  let(:check) { FactoryBot.create(:check, user: user, team: user.teams.first, uri: uri) }

  before do
    use_influxdb

    Trinity::Current.reset!
    sign_in user
  end

  describe 'GET /checks' do
    it 'when user has no check show hint-create button' do
      get checks_path

      expect(response).to have_http_status(200)
      expect(response.body).to include("Let's get start by adding your first check")
    end

    it 'list checks' do
      check

      get checks_path
      expect(response).to have_http_status(200)
      expect(response.body).to include(check.name)
    end

    it "doesn't show other user's check" do
      check
      c2 = FactoryBot.create(:check, user: user2, team: user2.teams.first, uri: uri)

      get '/checks'
      expect(response).to have_http_status(200)
      expect(response.body).to_not include(c2.uri)
    end

    xit 'shows team\'s check'
  end

  describe 'GET /checks/:id' do
    it 'shows check detail' do
      check

      get "/checks/#{check.id}"
      expect(response).to have_http_status(200)
      expect(response.body).to include(check.uri)
    end
  end

  describe 'GET /checks/new' do
    it 'shows to create check' do
      get new_check_path

      expect(response).to have_http_status(200)
      expect(response).to have_http_status(200)
    end
  end
end
