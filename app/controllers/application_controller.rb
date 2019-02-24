# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current
  # skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }

  private

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def current
    @current ||= Trinity::Current.instance(current_user, request, session)
  rescue StandardError => e
    Bugsnag.notify e

    raise e
  end
end
