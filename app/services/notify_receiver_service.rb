# Send out notification to receiver action
class NotifyReceiverService

  attr_reader :receiver, :incident
  def initialize(incident, receiver)
    @receiver = receiver
    @incident = incident
  end

  # Execute action
  def execute
    yeller = receiver.provider_class

    yeller.notify_incident(incident, receiver)
  end

  def self.execute(incident, receiver)
    yeller = receiver.provider_class

    yeller.notify_incident(incident, receiver)
  end
end
