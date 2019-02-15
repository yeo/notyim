# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Receivers', type: :request do
  describe 'GET /receivers' do
    it 'works! (now write some real specs)' do
      get receivers_path
      expect(response).to have_http_status(200)
    end
  end
end
