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

  def self.members(team)
    team.team_memberships
  end

  def self.find_team_from_host(domain)
    match = /team-([^\.]+)\.noty.*/.match domain
    if match && (team_id = match[1])
      Team.find team_id
    end
  end
end
