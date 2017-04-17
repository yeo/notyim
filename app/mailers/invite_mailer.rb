class InviteMailer < ApplicationMailer
  include Rails.application.routes.url_helpers

  # @param String to: emil to invite
  def invite(user, team, invite, to)
    @user = User.find user
    @team = Team.find team
    @invite = Invitation.find invite

    @url =  [verify_verification_url(@verification), "?code=", @verification.code].join('')
    mail(to: to, subject: "You have invited to team: #{team.name} on noty.im")
  end
end
