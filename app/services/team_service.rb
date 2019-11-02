# frozen_string_literal: true

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

    return unless match && (team_id = match[1])

    Team.find(team_id)
  end

  # Find a list of team that user belongs to
  # This include:
  # Team that user own and team that user is a member
  def self.fetch_user_teams(user)
    user.teams.to_a + user.team_memberships.map(&:team).to_a
  end
end
