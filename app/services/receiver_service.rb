class ReceiverService
  # Create receiver and its logic from parameter
  # @param Receiver object
  # @param boolean true false
  def self.save(receiver)
    if receiver.save! && receiver.require_verify?
      VerificationService.generate(receiver)
    end
  end
end
