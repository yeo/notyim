require 'rails_helper'

RSpec.describe "incidents/edit", type: :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :check => nil,
      :status => "MyString",
      :acknowledged_at => ""
    ))
  end

  it "renders the edit incident form" do
    render

    assert_select "form[action=?][method=?]", incident_path(@incident), "post" do

      assert_select "input#incident_check_id[name=?]", "incident[check_id]"

      assert_select "input#incident_status[name=?]", "incident[status]"

      assert_select "input#incident_acknowledged_at[name=?]", "incident[acknowledged_at]"
    end
  end
end
