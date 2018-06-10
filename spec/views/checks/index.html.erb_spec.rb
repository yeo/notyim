require 'rails_helper'

RSpec.describe 'checks/index', type: :view do
  let(:user) { create(:user) }

  before(:each) do
    assign(:checks, [
      create(:http_check, user: user, team: user.default_team, name: 'Check 1'),
      create(:http_check, user: user, team: user.default_team, name: 'Check 2')
    ])
  end

  it 'renders a list of checks' do
    render

    assert_select '.check', count: 2
    assert_select '.subtitle', 'Check 1'
    assert_select '.subtitle', 'Check 2'
    assert_select '.control > a', text: 'Detail', count: 2
    assert_select '.control > a', text: 'Config', count: 2
  end
end
