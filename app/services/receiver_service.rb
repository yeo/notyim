# frozen_string_literal: true

class ReceiverService
  # Create receiver and its logic from parameter
  # @param Receiver object
  # @param boolean true false
  def self.save(receiver)
    raise 'UserCannotManageTeam' unless can_view?(receiver)

    VerificationService.generate(receiver) if receiver.save! && receiver.require_verify?

    return unless receiver.provider_class.auto_assign_after_create?

    add_receiver_to_check(receiver, receiver.user.checks)
  end

  def self.add_receiver_to_check(receiver, checks)
    checks.each do |check|
      check.receivers ||= []
      check.receivers << receiver.id.to_s
      check.save!
    end
  end

  def self.can_view?(receiver)
    TeamPolicy.can_manage?(receiver.team, receiver.user) ||
      TeamPolicy.can_view?(receiver.team, receiver.user)
  end
  private_class_method :can_view?
end
