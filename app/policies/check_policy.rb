# frozen_string_literal: true

require 'trinity/policy'

class CheckPolicy
  extend Trinity::Policy::Base

  def self.can_manage?(check, user)
    check.user.id == user.id if user && check
  end
end
