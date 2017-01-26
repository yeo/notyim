require 'rails_helper'

RSpec.describe "notifications/edit", type: :view do
  before(:each) do
    @notification = assign(:notification, Notification.create!(
      :assertion => nil,
      :check => nil,
      :content => "MyString"
    ))
  end

  it "renders the edit notification form" do
    render

    assert_select "form[action=?][method=?]", notification_path(@notification), "post" do

      assert_select "input#notification_assertion_id[name=?]", "notification[assertion_id]"

      assert_select "input#notification_check_id[name=?]", "notification[check_id]"

      assert_select "input#notification_content[name=?]", "notification[content]"
    end
  end
end
