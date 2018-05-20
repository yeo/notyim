FactoryBot.define do
  factory :http_check, class: Check do
    name 'Http Checkk'
    type Check::TYPE_HTTP
    uri 'https://noty.im'
    # user FactoryBot.build(:user)
  end
end
