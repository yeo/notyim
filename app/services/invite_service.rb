# frozen_string_literal: true

require 'trinity'

class InviteService
  def self.invite(user, target, email)
    # TODO: check for policy
    invite = Invitation.new(invitable: target, email: email, user: user)
    invite.save!

    # Now fanout notification
    InviteMailer.invite(user.id.to_s, target.id.to_s, invite.id.to_s).deliver_later
  end

  def self.find_team_membership_request_by_code(code)
    Invitation.where(code: code).first&.invitable
  end
end
