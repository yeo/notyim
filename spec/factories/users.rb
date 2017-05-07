FactoryGirl.define  do
  factory :user, class: User do
    email "t-#{SecureRandom.hex}@noty.im"
    name 'test'
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now.utc
    teams [FactoryGirl.build(:team)]

    after :build do |user|
      user.skip_confirmation_notification!
    end

    after :create do |user|
      FactoryGirl.create(:team, user: user)
    end
  end

  factory :admin, class: User do
    email 'admin@noty.im'
    name 'Admin'
    admin true
    password '123456789'
    password_confirmation '123456789'
    confirmed_at Time.now.utc
    teams [FactoryGirl.build(:team)]
  end
end
