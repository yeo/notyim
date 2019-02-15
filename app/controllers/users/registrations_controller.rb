# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  layout 'dashboard', only: [:edit]
end
