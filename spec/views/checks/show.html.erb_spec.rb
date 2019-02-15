# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'checks/show', type: :view do
  let(:user) { create(:user) }
  let(:check) do
    create(:check, user: user, team: user.default_team, name: 'Check 1')
  end

  before(:each) do
    assign(:check, check)
  end

  it 'renders attributes in <p>' do
    render

    assert_select '.check-item__title > a', check.uri
    expect(rendered).to match(/Last hour/)
    expect(rendered).to match(/Last 24 hour/)
    expect(rendered).to match(/Uptime/)
  end
end
