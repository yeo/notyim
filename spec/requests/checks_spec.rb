require 'rails_helper'

RSpec.describe "Checks", type: :request do
  describe "GET /checks" do
    it "works! (now write some real specs)" do
      get checks_path
      expect(response).to have_http_status(200)
    end
  end
end
