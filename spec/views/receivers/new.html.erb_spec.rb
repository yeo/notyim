require 'rails_helper'

RSpec.describe "receivers/new", type: :view do
  before(:each) do
    assign(:receiver, Receiver.new(
      :user => nil,
      :provider => "MyString",
      :handler => "MyString",
      :require_verify => false,
      :verified => false
    ))
  end

  it "renders new receiver form" do
    render

    assert_select "form[action=?][method=?]", receivers_path, "post" do

      assert_select "input#receiver_user_id[name=?]", "receiver[user_id]"

      assert_select "input#receiver_provider[name=?]", "receiver[provider]"

      assert_select "input#receiver_handler[name=?]", "receiver[handler]"

      assert_select "input#receiver_require_verify[name=?]", "receiver[require_verify]"

      assert_select "input#receiver_verified[name=?]", "receiver[verified]"
    end
  end
end
