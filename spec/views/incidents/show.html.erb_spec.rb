require 'rails_helper'

RSpec.describe 'incidents/show', type: :view do
  let(:incident) { FactoryBot.create(:incident, status: 'closed') }

  before(:each) do
    @incident = assign(:incident, incident)

    render
  end

  it 'render status' do
    expect(rendered).to match(/#{incident.status}/)
    expect(rendered).to match(/Status/)
  end

  it 'render check' do
    expect(rendered).to match(/#{incident.check.name}/)
  end

  it 'render assertion' do
    expect(rendered).to match(/#{incident.assertion.subject}/)
  end
end
