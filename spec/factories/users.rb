FactoryGirl.define  do
  factory :user, class: User do
    email 'test@noty.im'
    name 'test'
    password '123456789'
    confirmed_at Time.now.utc
    teams [FactoryGirl.build(:team)]
  end

  factory :admin, class: User do
    email 'admin@noty.im'
    name 'Admin'
    admin true
    confirmed_at Time.now.utc
  end
end
