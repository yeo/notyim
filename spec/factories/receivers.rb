# frozen_string_literal: true

FactoryBot.define do
  factory :receiver, class: Receiver do
    provider 'Email'
    name 'email'
    handler 'r@noty.im'
    require_verify true
    verified true

    team { FactoryBot.create(:team) }
    user { team.user }

    after :create do |r|
      Verification.create!(verified_at: Time.now, verifiable: r) if r.provider == 'Email'
    end

    factory :slack_receiver, class: Receiver do
      provider 'Slack'
      handler '1234'
      name 'slack'
      require_verify false
      verified false
    end
  end
end
