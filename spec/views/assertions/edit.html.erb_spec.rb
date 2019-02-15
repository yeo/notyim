# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'assertions/edit', type: :view do
  let(:check) { FactoryBot.build(:check) }
  let(:user) { check.user }
  let(:assertion) { FactoryBot.create(:assertion, check: check) }

  before(:each) do
    @assertion = assign(:assertion, assertion)
  end

  it 'renders the edit assertion form' do
    render

    assert_select 'form[action=?][method=?]', assertion_path(@assertion), 'post' do
      assert_select 'input#assertion_check_id[name=?]', 'assertion[check_id]'
    end
  end
end
