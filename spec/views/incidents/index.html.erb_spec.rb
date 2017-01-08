require 'rails_helper'

RSpec.describe "incidents/index", type: :view do
  before(:each) do
    assign(:incidents, [
      Incident.create!(
        :check => nil,
        :status => "Status",
        :acknowledged_at => ""
      ),
      Incident.create!(
        :check => nil,
        :status => "Status",
        :acknowledged_at => ""
      )
    ])
  end

  it "renders a list of incidents" do
    render
    assert_select "tr>td", :text => nil.to_s, :count => 2
    assert_select "tr>td", :text => "Status".to_s, :count => 2
    assert_select "tr>td", :text => "".to_s, :count => 2
  end
end
