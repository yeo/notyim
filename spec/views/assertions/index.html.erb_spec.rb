require 'rails_helper'

RSpec.describe "assertions/index", type: :view do
  before(:each) do
    assign(:assertions, [
      Assertion.create!(
        :check => nil,
        :subject => "Subject",
        :condition => "Condition"
      ),
      Assertion.create!(
        :check => nil,
        :subject => "Subject",
        :condition => "Condition"
      )
    ])
  end

  it "renders a list of assertions" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Subject".to_s, :count => 2
    assert_select "tr>td", :text => "Condition".to_s, :count => 2
  end
end
