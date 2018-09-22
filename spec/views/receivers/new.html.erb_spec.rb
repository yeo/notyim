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

    Yeller::Provider.providers.keys.select { |p| Yeller::Provider.class_of(p).support_add_form? }
      .each do |p|
      assert_select ".alertcontact-provider-#{p}", count: 1
      assert_select "form[action=?][method=?]", receivers_path, "post" do
        assert_select "input[name=?]", "receiver[name]"
        assert_select "input[name=?]", "receiver[handler]"
        assert_select "input[name=?]", "receiver[provider]", value: p
        assert_select "input[name=?]", "commit", type: 'submit'
      end
    end
  end
end
