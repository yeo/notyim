# frozen_string_literal: true

class CheckService
  # Register those receiver for this check.
  # When an incident happens, those receiver will receive notificaion
  # @params Check check
  # @param Array[Receiver|ObjectID]
  def self.register_receivers(check, receivers)
    check.receivers = []
    if receivers.present?
      Receiver.find(receivers).each { |r| check.receivers << r.id.to_s if r.user == check.user }
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
          condition: 'down'
        ),
        Assertion.new(
          subject: "#{Check::TYPE_HTTP}.code",
          condition: 'ne',
          operand: '200'
        )
      ]
    end
  end

  def self.auto_create_assertions(id)
    check = Check.find(id.to_s)

    if check.assertions.empty?
      check.assertions = CheckService.default_assertions_for_type(check.type)
      check.save!
    end
  end
end
