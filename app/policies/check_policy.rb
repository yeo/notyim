require 'trinity/policy'

class CheckPolicy
  extend Trinity::Policy::Base

  def self.can_manage?(check, user)
    if user && check
      check.user.id == user.id
    end
  end
end
