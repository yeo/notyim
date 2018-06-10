require 'rails_helper'

RSpec.describe "checks/edit", type: :view do
  let(:user) { create(:user) }
  let(:check) {
      create(:http_check, user: user, team: user.default_team, name: 'Check 1')
  }

  before(:each) do
    @check = assign(:check, check)

    assign(:current, double("Trinity::Current", user: user))
  end

  it "renders the edit check form" do
    render

    expect(rendered).to match(/https:\/\/status-#{check.id.to_s}\.noty\.im/)
    assert_select "a", check.name
    assert_select "a[href=?]",check_path(@check), "Destroy!"
    assert_select "form[action=?][method=?]", check_path(@check), "post" do
      assert_select "input#check_name[name=?]", "check[name]"
      assert_select "input#check_uri[name=?]", "check[uri]"
      assert_select "select#check_type[name=?]", "check[type]"
    end
  end
end
