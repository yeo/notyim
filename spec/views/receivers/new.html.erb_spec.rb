require 'rails_helper'

RSpec.describe "receivers/new", type: :view do
  include HomeHelper

  before(:each) do
    assign(:receiver, Receiver.new(
      :provider => "Email",
    ))
  end

  it "renders new receiver form" do
    render

    assert_select "a.button[href=?]", new_slack_url, text: "Connect Slack Bot", count: 1
    assert_select "a.button[href=?]", new_telegram_url, text: "Connect Telegram Bot", count: 1
    assert_select ".alertcontact-provider",
      count: Yeller::Provider.providers.count { |provider|
        Yeller::Provider.class_of(provider.first).support_add_form?
      }

    Yeller::Provider.providers.each do |provider|
      assert_select ".alertcontact-provider-#{provider}", count: 1
    end

    assert_select "form[action=?][method=?]", receivers_path, "post" do
      assert_select "input[name=?]", "receiver[user_id]"
      assert_select "input#receiver_provider[name=name]", "receiver[provider]"
      assert_select "input#receiver_handler[name=?]", "receiver[handler]"
      assert_select "input#receiver_require_verify[name=?]", "receiver[require_verify]"
      assert_select "input#receiver_verified[name=?]", "receiver[verified]"
    end
  end
end
