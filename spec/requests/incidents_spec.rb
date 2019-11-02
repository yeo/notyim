# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Incidents', type: :request do
  describe 'GET /incidents' do
    xit 'lists open incident' do
      get incidents_path
      expect(response).to have_http_status(200)
    end

    xit 'shows all incident with flag'
  end

  describe 'GET /incidnets/:id' do
    xit 'show detail incident'
  end
end
