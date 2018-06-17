# frozen_string_literal: true
require 'rails_helper'

RSpec.describe "teams/index", type: :view do
  let(:t1) { FactoryBot.create(:team) }
  let(:t2) { FactoryBot.create(:team, user: t1.user, name: 'team 2') }

  before(:each) do
    assign(:teams, [t1, t2])
    assign(:team, t1)
    render
  end

  it "renders a list of teams" do
    assert_select ".team-list a", text: t1.name, count: 1
    assert_select ".team-list a", text: t2.name, count: 1
    assert_select ".team-list #team-control-#{t1.id.to_s} > .current-team", count: 1
    assert_select "a.button.is-danger[href=?]", team_path(t1), text: 'Delete team', count: 1
  end

  xit "render pendin invitation" do

  end

  xit "render memers list" do

  end

end
