require 'rails_helper'

RSpec.describe "assertions/new", type: :view do
  before(:each) do
    assign(:assertion, Assertion.new(
      :check => nil,
      :subject => "MyString",
      :condition => "MyString"
    ))
  end

  it "renders new assertion form" do
    render

    assert_select "form[action=?][method=?]", assertions_path, "post" do

      assert_select "input#assertion_check_id[name=?]", "assertion[check_id]"

      assert_select "input#assertion_subject[name=?]", "assertion[subject]"

      assert_select "input#assertion_condition[name=?]", "assertion[condition]"
    end
  end
end
