# frozen_string_literal: true

RSpec.shared_examples 'require authenticated user' do |path|
  it 'redirecsts to login page' do
    get path

    expect(response).to have_http_status(302)
    expect(response.location).to eq('http://www.example.com/users/sign_in')
  end
end
