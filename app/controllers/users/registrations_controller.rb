class Users::RegistrationsController < Devise::RegistrationsController
  layout "dashboard", only: [:edit]
end
