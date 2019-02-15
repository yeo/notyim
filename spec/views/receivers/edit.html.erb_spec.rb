# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'receivers/edit', type: :view do
  include HomeHelper

  before(:each) do
    @receiver = assign(:receiver, FactoryBot.create(:receiver))
  end

  it 'renders the edit receiver form' do
    render

    assert_select 'form[action=?][method=?]', receiver_path(@receiver), 'post' do
      assert_select 'input[name=?][value=?]', 'receiver[name]', @receiver.name
      assert_select 'input[name=?][value=?]', 'receiver[handler]', @receiver.handler
    end
  end

  it 'renders resend button for unverfied receiver' do
    render

    assert_select 'form[action=?][method=?]', "/verification/#{@receiver.last_verification.id}/resend", 'post' do
      assert_select 'input[name=?][value=?]', 'commit', 'Resend verification code'
    end
  end

  it "doesn't render resend button for verified receiver" do
    @receiver.verify!

    render

    assert_select 'form[action=?][method=?]', "/verification/#{@receiver.last_verification.id}/resend", 'post', count: 0
    assert_select 'input[name=?][value=?]', 'commit', 'Resend verification code', count: 0
  end
end
