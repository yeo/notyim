require 'trinity/policy'

class TeamPolicy
  extend Trinity::Policy::Base

  def self.can_manage?(team, user)
    if user && team
      team.user.id == user.id
    end
  end
end
