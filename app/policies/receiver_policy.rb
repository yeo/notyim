require 'trinity/policy'

class ReceiverPolicy < CheckPolicy
  def self.can_manage?(receiver, user)
    if user && receiver
      receiver.user.id == user.id
    end
  end
end
