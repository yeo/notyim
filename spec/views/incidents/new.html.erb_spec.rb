require 'rails_helper'

RSpec.describe "incidents/new", type: :view do
  before(:each) do
    assign(:incident, Incident.new(
      :check => nil,
      :status => "MyString",
      :acknowledged_at => ""
    ))
  end

  it "renders new incident form" do
    render

    assert_select "form[action=?][method=?]", incidents_path, "post" do

      assert_select "input#incident_check_id[name=?]", "incident[check_id]"

      assert_select "input#incident_status[name=?]", "incident[status]"

      assert_select "input#incident_acknowledged_at[name=?]", "incident[acknowledged_at]"
    end
  end
end
