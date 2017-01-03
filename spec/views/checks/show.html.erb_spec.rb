require 'rails_helper'

RSpec.describe "checks/show", type: :view do
  before(:each) do
    @check = assign(:check, Check.create!(
      :name => "Name",
      :uri => "Uri",
      :type => "Type"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Name/)
    expect(rendered).to match(/Uri/)
    expect(rendered).to match(/Type/)
  end
end
