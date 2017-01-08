class CheckService
  # Register those receiver for this check.
  # When an incident happens, those receiver will receive notificaion
  # @params Check check
  # @param Array[Receiver|ObjectID]
  def self.register_receivers(check, receivers)
    check.receivers = []
    Receiver.find(receivers).each do |r|
      if r.user == check.user
        check.receivers << r.id.to_s
      end
    end
    check.save!
  end
end
