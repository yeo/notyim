class TeamService
  # Accept an invitation
  def self.accept_invite(user, invite)
    join invite.invitable, user
    invite.accepted_at = Time.now
    invite.save!
  end

  def self.join(team, user)
    TeamMembership.create!(
      team: team,
      user: user,
      role: TeamMembership::ROLE_EDITOR
    )
  end
end
