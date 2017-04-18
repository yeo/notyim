class InviteMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  # @params User user
  # @params Team team
  # @param Invitation invite
  def invite(user, team, invite)
    @user = User.find user
    @team = Team.find team
    @invite = Invitation.find invite

    @url =  [team_invitation_url(@invite), "?code=", @invite.code].join('')
    mail(to: @invite.email, subject: "#{@user.email} has invited to join team: #{@team.name}")
  end
end
