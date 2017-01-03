require 'rails_helper'

RSpec.describe "checks/edit", type: :view do
  before(:each) do
    @check = assign(:check, Check.create!(
      :name => "MyString",
      :uri => "MyString",
      :type => ""
    ))
  end

  it "renders the edit check form" do
    render

    assert_select "form[action=?][method=?]", check_path(@check), "post" do

      assert_select "input#check_name[name=?]", "check[name]"

      assert_select "input#check_uri[name=?]", "check[uri]"

      assert_select "input#check_type[name=?]", "check[type]"
    end
  end
end
