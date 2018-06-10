# frozen_string_literal: true
FactoryBot.define  do
  factory :user, class: User do
    email "t-#{SecureRandom.hex}@noty.im"
    name 'test'
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now.utc
    teams [FactoryBot.build(:team)]

    after :build do |user|
      user.skip_confirmation_notification!
      user.skip_confirmation!
    end

    after :create do |user|
      FactoryBot.create(:team, user: user)
    end
  end

  factory :admin, class: User do
    email 'admin@noty.im'
    name 'Admin'
    admin true
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now.utc
    teams [FactoryBot.build(:team)]
  end
end
