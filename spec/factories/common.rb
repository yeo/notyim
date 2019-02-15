# frozen_string_literal: true

FactoryBot.define do
  factory :user, class: User do
    email { "t-#{SecureRandom.hex}@noty.im" }
    name 'test'
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now.utc
    # teams [FactoryBot.build(:team)]

    before :save do |user|
      puts user.email

      user.skip_confirmation_notification!
      user.skip_confirmation!
    end

    factory :admin, class: User do
      email 'admin@noty.im'
      name 'Admin'
      admin true
    end
  end

  factory :team do
    name "Team #{SecureRandom.hex}"
    user { FactoryBot.create(:user) }
  end

  factory :check, class: Check do
    name 'Http Check'
    type Check::TYPE_HTTP
    uri 'https://noty.im'

    factory :check_with_user, class: Check do
      team { FactoryBot.create(:team) }
      user { team.user }
    end
  end

  factory :incident, class: Incident do
    status 'open'
    error_message 'Request reject'
    locations(open: %w[1.1.1.1])

    check { FactoryBot.create(:check_with_user) }

    assertion { FactoryBot.create(:assertion, check: check) }
    team { FactoryBot.create(:team) }
    user { team.user }
  end

  factory :check_response do
    raw_result(
      check_id: 123,
      type: 'http',
      time: [],
      body: 'ok',
      error: false,
      error_message: nil,
      http: {},
      from_ip: '1.2.3.4',
      from_region: 'us'
    )
  end
end
