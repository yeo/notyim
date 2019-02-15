# frozen_string_literal: true

class TeamMembershipsController < DashboardController
  def create
    team = Team.find params[:invitation][:invitable]
    if InviteService.invite(team, params[:invitation][:email])
      redirect show_team_path(team), notice: 'We send out invitation'
    else
      redirect show_team_path(team), notice: 'An error has occur. Please check email'
    end
  end
end
