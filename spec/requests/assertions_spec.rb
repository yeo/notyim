require 'rails_helper'

RSpec.describe "Assertions", type: :request do
  describe "GET /assertions" do
    it "works! (now write some real specs)" do
      get assertions_path
      expect(response).to have_http_status(200)
    end
  end
end
