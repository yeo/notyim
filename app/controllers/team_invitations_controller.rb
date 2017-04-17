class TeamInvitationsController < DashboardController
  def create
    team = Team.find params[:team]
    if InviteService.invite(current.user, team, params[:email])
      redirect_to team, notice: "We send out invitation"
    else
      redirect_to team, notice: "An error has occur. Please check email"
    end
  end
end
