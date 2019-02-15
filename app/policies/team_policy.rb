# frozen_string_literal: true

require 'trinity/policy'

class TeamPolicy
  extend Trinity::Policy::Base

  def self.can_manage?(team, user)
    team.user.id == user.id if user && team
  end

  def self.can_view?(team, user)
    team.team_memberships.where(user: user).count >= 1
  end
end
