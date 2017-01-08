require 'rails_helper'

RSpec.describe "incidents/show", type: :view do
  before(:each) do
    @incident = assign(:incident, Incident.create!(
      :check => nil,
      :status => "Status",
      :acknowledged_at => ""
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Status/)
    expect(rendered).to match(//)
  end
end
