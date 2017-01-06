require 'rails_helper'

RSpec.describe "assertions/show", type: :view do
  before(:each) do
    @assertion = assign(:assertion, Assertion.create!(
      :check => nil,
      :subject => "Subject",
      :condition => "Condition"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Subject/)
    expect(rendered).to match(/Condition/)
  end
end
