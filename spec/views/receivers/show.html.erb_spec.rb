require 'rails_helper'

RSpec.describe "receivers/show", type: :view do
  before(:each) do
    @receiver = assign(:receiver, Receiver.create!(
      :user => nil,
      :provider => "Provider",
      :handler => "Handler",
      :require_verify => false,
      :verified => false
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(//)
    expect(rendered).to match(/Provider/)
    expect(rendered).to match(/Handler/)
    expect(rendered).to match(/false/)
    expect(rendered).to match(/false/)
  end
end
