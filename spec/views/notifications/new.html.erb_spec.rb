require 'rails_helper'

RSpec.describe "notifications/new", type: :view do
  before(:each) do
    assign(:notification, Notification.new(
      :assertion => nil,
      :check => nil,
      :content => "MyString"
    ))
  end

  it "renders new notification form" do
    render

    assert_select "form[action=?][method=?]", notifications_path, "post" do

      assert_select "input#notification_assertion_id[name=?]", "notification[assertion_id]"

      assert_select "input#notification_check_id[name=?]", "notification[check_id]"

      assert_select "input#notification_content[name=?]", "notification[content]"
    end
  end
end
