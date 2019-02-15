# frozen_string_literal: true

class TeamInvitationsController < DashboardController
  before_action :check_invite, only: %i[show update]

  def create
    team = Team.find params[:team]

    return head :forbidden unless TeamPolicy.can_manage?(team, current.user)

    if InviteService.invite(current.user, team, params[:email])
      redirect_to team, notice: 'We send out invitation'
    else
      redirect_to team, notice: 'An error has occur. Please check email'
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
    return head :forbidden if @invite.code != params[:code]

    if @invite.email != current_user.email
      redirect_to user_root_path, alert: "The invitation email wasn't match your email account"
    end

    redirect_to user_root_path, alert: 'The invitation has been used already' if @invite.accepted_at
  end
end
