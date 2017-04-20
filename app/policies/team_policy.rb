require 'trinity/policy'

class TeamPolicy
  extend Trinity::Policy::Base

  def self.can_manage?(team, user)
    if user && team
      team.user.id == user.id
    end
  end

  def self.can_view?(team, user)
    team.team_memberships.where(user: user).count >= 1
  end
end
