# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'incidents/index', type: :view do
  let(:incident1) { FactoryBot.create(:incident, status: 'closed') }
  let(:incident2) { FactoryBot.create(:incident) }
  let(:incidents) do
    Kaminari::PaginatableArray.new([incident1, incident2]).page(1).per(5).padding(5)
  end

  before(:each) do
    assign(:incidents, incidents)
  end

  it 'renders a list of incidents' do
    render

    assert_select 'a.button.is-primary', text: 'Open incidents', count: 1
    assert_select 'a.button', text: 'All incidents', count: 1
    # assert_select 'tr>td', :text => nil.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Status'.to_s, :count => 2
    # assert_select 'tr>td', :text => ''.to_s, :count => 2
  end
end
