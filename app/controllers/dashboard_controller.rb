require 'trinity/current'

class DashboardController < ActionController::Base
  layout 'dashboard'
  before_action :authenticate_user!, :team_pick!

  private
  def current
    @__current ||= Trinity::Current.instance
  end

  def team_pick!
    if session[:team]
      if TeamPolicy.owner? team
        current.team = session[:team]
      else
        current.team = session[:team] = nil
      end
    end
  end
end
