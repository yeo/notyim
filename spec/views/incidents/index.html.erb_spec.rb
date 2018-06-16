require 'rails_helper'

RSpec.describe 'incidents/index', type: :view do
  let(:user) { create(:user) }
  let(:incident1) { build(:incident) }
  let(:incident2) { build(:incident) }

  before(:each) do
    assign(:incidents, [check1, check2])
  end

  it 'renders a list of incidents' do
    render

    assert_select 'a.button.is-privacy', text: 'Open incidents', count: 1
    # assert_select 'tr>td', :text => nil.to_s, :count => 2
    # assert_select 'tr>td', :text => 'Status'.to_s, :count => 2
    # assert_select 'tr>td', :text => ''.to_s, :count => 2
  end
end
