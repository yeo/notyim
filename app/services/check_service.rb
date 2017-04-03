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

  # Generate default assertions
  #
  # When a check is created, we have some default assertions that we want to get created automatically
  def self.default_assertions_for_type(type)
    case type
    when Check::TYPE_HTTP
      [
        Assertion.new(
          subject: "#{Check::TYPE_HTTP}.status",
          condition: 'down',
        ),
        Assertion.new(
          subject: "#{Check::TYPE_HTTP}.code",
          condition: 'ne',
          operand: '200'
        ),
      ]
    end
  end
end
