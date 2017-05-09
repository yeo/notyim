FactoryGirl.define do
  factory :http_check, class: Check do
    name 'Http Checkk'
    type Check::TYPE_HTTP
    uri 'https://noty.im'
    user FactoryGirl.build(:user)

    after_create do |check|
      FactoryGirl.create(:incident, team: check.team, user: check.user)
    end
  end
end
