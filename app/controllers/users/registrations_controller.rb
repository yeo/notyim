# frozen_string_literal: true

class Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'dashboard', only: [:edit]
  end
end
