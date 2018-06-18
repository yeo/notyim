require 'rails_helper'

RSpec.describe "receivers/index", type: :view do
  let(:email_receiver) { FactoryBot.create(:receiver) }
  let(:slack_receiver) { FactoryBot.create(:slack_receiver) }

  before(:each) do
    @receivers = [email_receiver, slack_receiver]
    assign(:receivers, @receivers)

    render
  end

  it "renders a list of receivers" do
    assert_select "a.button.is-primary[href=?]", new_receiver_path, text: 'Add new alert channel', count: 2
    @receivers.each do |r|
      assert_select "h4.title", text: r.provider, count: 1
      expect(rendered).to match(/#{r.handler}/)
    end
  end

  xit "renders receiver not verified yet" do

  end

  xit "renders not-editable receiver" do

  end
end
