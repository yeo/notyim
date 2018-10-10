# frozen_string_literal: true

require 'trinity/policy'

# Policy for check/alert channel acl
class ReceiverPolicy < CheckPolicy
  def self.can_manage?(receiver, user)
    user && receiver && receiver.user.id == user.id
  end
end
