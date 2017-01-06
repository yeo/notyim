require 'rails_helper'

RSpec.describe "receivers/index", type: :view do
  before(:each) do
    assign(:receivers, [
      Receiver.create!(
        :user => nil,
        :provider => "Provider",
        :handler => "Handler",
        :require_verify => false,
        :verified => false
      ),
      Receiver.create!(
        :user => nil,
        :provider => "Provider",
        :handler => "Handler",
        :require_verify => false,
        :verified => false
      )
    ])
  end

  it "renders a list of receivers" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Provider".to_s, :count => 2
    assert_select "tr>td", :text => "Handler".to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
    assert_select "tr>td", :text => false.to_s, :count => 2
  end
end
