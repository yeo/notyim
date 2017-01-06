require 'rails_helper'

RSpec.describe "assertions/edit", type: :view do
  before(:each) do
    @assertion = assign(:assertion, Assertion.create!(
      :check => nil,
      :subject => "MyString",
      :condition => "MyString"
    ))
  end

  it "renders the edit assertion form" do
    render

    assert_select "form[action=?][method=?]", assertion_path(@assertion), "post" do

      assert_select "input#assertion_check_id[name=?]", "assertion[check_id]"

      assert_select "input#assertion_subject[name=?]", "assertion[subject]"

      assert_select "input#assertion_condition[name=?]", "assertion[condition]"
    end
  end
end
