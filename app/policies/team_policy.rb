class TeamPolicy
  extend Trinity::Policy::Base

  def can_manage?(team, user)
    if user && team
      user.team.id == team.id
    end
  end
end
