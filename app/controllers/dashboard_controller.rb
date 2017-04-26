require 'trinity/current'
require 'trinity/policy'

class DashboardController < ApplicationController
  layout 'dashboard'
  before_action :authenticate_user!, :team_pick!

  private
  def team_pick!
    begin
      # TODO: Remove those magic string
      if request.host.start_with?('team-') && (request.host.end_with?('noty.im') || request.host.end_with?('noty.dev'))
        # TODO: Cache or do domain -> team mapping
        team = TeamService.find_team_from_host request.host
        if TeamPolicy.can_manage?(team, current.user) || TeamPolicy.can_view?(team, current.user)
          session[:team] = team.id.to_s
        else
          return head :forbidden
        end
      end

      if session[:team] && (team = Team.find(session[:team]))
        if TeamPolicy.can_manage?(team, current.user) || TeamPolicy.can_view?(team, current.user)
          current.team = team
        else
          current.team = session[:team] = nil
          return head :forbidden
        end
      else
        current.team = current.user.default_team
        session[:team] = current.user.default_team.id.to_s
      end

    rescue => e
      # This is terrible wrong, we need to log it
      # and look into its manually
      Bugsnag.notify e
      session[:team] = nil
      head :forbidden
    end
  end
end
