# frozen_string_literal: true

module Users
  class RegistrationsController < Devise::RegistrationsController
    layout 'dashboard', only: [:edit]
  end
end
