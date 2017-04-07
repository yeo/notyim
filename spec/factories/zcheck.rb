FactoryGirl.define do
  factory :http_check, class: Check do
  name 'Http Checkk'
  uri 'https://noty.im'
  user FactoryGirl.build(:user)
  team FactoryGirl.build(:team)
  end
end
