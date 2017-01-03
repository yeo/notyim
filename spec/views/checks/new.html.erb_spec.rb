require 'rails_helper'

RSpec.describe "checks/new", type: :view do
  before(:each) do
    assign(:check, Check.new(
      :name => "MyString",
      :uri => "MyString",
      :type => ""
    ))
  end

  it "renders new check form" do
    render

    assert_select "form[action=?][method=?]", checks_path, "post" do

      assert_select "input#check_name[name=?]", "check[name]"

      assert_select "input#check_uri[name=?]", "check[uri]"

      assert_select "input#check_type[name=?]", "check[type]"
    end
  end
end
