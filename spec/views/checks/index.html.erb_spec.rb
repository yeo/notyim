require 'rails_helper'

RSpec.describe "checks/index", type: :view do
  before(:each) do
    assign(:checks, [
      Check.create!(
        :name => "Name",
        :uri => "Uri",
        :type => "Type"
      ),
      Check.create!(
        :name => "Name",
        :uri => "Uri",
        :type => "Type"
      )
    ])
  end

  it "renders a list of checks" do
    render
    assert_select "tr>td", :text => "Name".to_s, :count => 2
    assert_select "tr>td", :text => "Uri".to_s, :count => 2
    assert_select "tr>td", :text => "Type".to_s, :count => 2
  end
end
