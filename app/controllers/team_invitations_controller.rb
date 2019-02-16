# frozen_string_literal: true

class TeamInvitationsController < DashboardController
  before_action :set_invite, :check_invite, only: %i[show update]

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
      return redirect_to root_url, notice: t('team.confirm_join', name: @invite.invitable.name)
    end

    head :internal_server_error
  end

  private

  def set_invite
    @invite = Invitation.find params[:id]
    @code = @invite.code
    return head(:forbidden) unless @code&.present?
  rescue Mongoid::Errors::DocumentNotFound
    redirect_to root_url, alert: t('team.invite_code_invalid')
  end

  def check_invite
    return head(:forbidden) if @code != params[:code]

    alert = if @invite.email != current_user.email
              'team.invite_code_mismatch'
            elsif @invite.accepted_at
              'team.invite_is_used'
            end

    redirect_to user_root_path, alert: t(alert)
  end
end
