require 'rails_helper'

RSpec.describe "receivers/edit", type: :view do
  include HomeHelper

  before(:each) do
    @receiver = assign(:receiver, Receiver.create!(
      :user => nil,
      :provider => "MyString",
      :handler => "MyString",
      :require_verify => false,
      :verified => false
    ))
  end

  it "renders the edit receiver form" do
    render

    assert_select "form[action=?][method=?]", receiver_path(@receiver), "post" do

      assert_select "input#receiver_user_id[name=?]", "receiver[user_id]"

      assert_select "input#receiver_provider[name=?]", "receiver[provider]"

      assert_select "input#receiver_handler[name=?]", "receiver[handler]"

      assert_select "input#receiver_require_verify[name=?]", "receiver[require_verify]"

      assert_select "input#receiver_verified[name=?]", "receiver[verified]"
    end
  end
end
