require 'trinity/current'
require 'trinity/policy'

class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!, :team_pick!

  private
  def current
    @__current ||= Trinity::Current.instance current_user
  end

  def team_pick!
    if team = session[:team]
      if TeamPolicy.can_manage?(team, current.user)
        current.team = team
      else
        current.team = session[:team] = nil
      end
    else
      current.team = session[:team] = current.user.teams.first
    end
  end
end
