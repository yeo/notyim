# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :current, :set_raven_context
  # skip_before_filter :verify_authenticity_token, if: -> { controller_name == 'sessions' && action_name == 'create' }

  private

  def not_found
    raise ActionController::RoutingError, 'Not Found'
  end

  def current
    @current ||= Trinity::Current.instance(current_user, request, session)
  rescue StandardError => e
    Raven.capture_exception(e)

    raise e
  end

  def set_raven_context
    Raven.user_context(id: session[:current_user_id]) # or anything else in session
    Raven.extra_context(params: params.to_unsafe_h, url: request.url)
  end
end
