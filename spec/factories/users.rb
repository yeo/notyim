FactoryGirl.define  do
  factory :user, class: User do
    email 'test@noty.im'
    name 'test'
    password '123456789'
  end

  factory :admin, class: User do
    email 'admin@noty.im'
    name 'Admin'
    admin true
  end
end
