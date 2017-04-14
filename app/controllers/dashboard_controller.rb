require 'trinity/current'
require 'trinity/policy'

class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!, :team_pick!

  private
  def team_pick!
    begin
      if session[:team] && (team = Team.find(session[:team]))
        if TeamPolicy.can_manage?(team, current.user)
          current.team = team
        else
          current.team = session[:team] = nil
        end
      else
        current.team = session[:team] = current.user.teams.first.id.to_s
      end
    rescue => e
      session[:team] = nil
      # TODO Log it
    end
  end
end
