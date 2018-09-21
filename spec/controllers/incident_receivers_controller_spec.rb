require 'rails_helper'

RSpec.describe IncidentReceiversController, type: :controller do
  let(:check) { gen_check_and_assertion }

  describe "GET #create" do
    it "returns http success" do
      get :create
      expect(response).to have_http_status(:success)
    end

    it 'creates receiver' do
      sign_in user.check
      check = FactoryBot.create(:check)
      allow(CheckService).to receive(:register_receivers).with(check, :foo).and_return(true)
      post :create, check_id: check.id.to_s, contact_receivers: "foo"
      assert_redirected_to root_path
    end

    it 'does not create when has no permission on check' do
      sign_in user.check
      user2 = FactoryBot.create(:user)
      check = FactoryBot.create(:check, user: user2)

      allow(CheckService).to receive(:register_receivers).with(check, :foo).and_return(true)
      post :create, check_id: check.id.to_s, contact_receivers: "foo"
      assert_response :forbidden
    end
  end
end
