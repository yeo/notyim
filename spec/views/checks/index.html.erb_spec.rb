# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'checks/index', type: :view do
  let(:check1) { FactoryBot.create(:check_with_user, name: 'Check 1') }
  let(:check2) { FactoryBot.create(:check, user: check1.user, team: check1.user.default_team, name: 'Check 2') }

  before(:each) do
    assign(:checks, [check1, check2])

    use_influxdb
  end

  after(:each) do
    cleanup_influxdb!
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
