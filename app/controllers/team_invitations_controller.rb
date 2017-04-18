class TeamInvitationsController < DashboardController
  before_action :check_invite

  def create
    team = Team.find params[:team]
    if InviteService.invite(current.user, team, params[:email])
      redirect_to team, notice: "We send out invitation"
    else
      redirect_to team, notice: "An error has occur. Please check email"
    end
  end

  # Show invitation
  def show
    @code = @invite.code
  end

  # Accept invitation, when an update occurs, we accept the invite
  def update
    if TeamService.accept_invite(current.user, @invite)
      # TODO: Redirect to team login page
      redirect_to root_url, notice: "You are now a member of team #{@invite.invitable.name}"
    end
  end

  private
  def check_invite
    @invite = Invitation.find params[:id]
    if @invite.code != params[:code]
      return head :forbidden
    end

    if @invite.email != current_user.email
      redirect_to user_root_path, alert: "The invitation email wasn't match your email account"
    end

    if @invite.accepted_at
      redirect_to user_root_path, alert: "The invitation has been used already"
    end
  end
end
