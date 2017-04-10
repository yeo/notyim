class IncidentDecorator < SimpleDelegator
  include ActionView::Helpers::TextHelper
  include Rails.application.routes.url_helpers
  include Trinity::Decorator

  def short_status
    case status
    when Incident::STATUS_OPEN
      'open'
    when Incident::STATUS_CLOSE
      'close'
    end
  end

  # Short summary in body for chat etc
  def short_summary
    "<strong>#{short_status.upcase} alert</strong> for #{check.uri}"
  end
  def short_summary_plain
    "*#{short_status.upcase} alert* for #{check.uri}"
  end


  def icon
    case status
    when Incident::STATUS_OPEN
      '▼'
    when Incident::STATUS_CLOSE
      '▲'
    end
  end

  # Generate a friendly reason text for the incident
  #
  # We then can use this to send a short text to end user
  def reason
    #TODO Refactor this into its own class
    case check.type
      when Check::TYPE_HTTP
        http_reason
      when Check::TYPE_TCP
        tcp_reason
      when Check::TYPE_HEARTBEAT
        hearbeat_reason
    end
  end

  def http_reason
    _subject = assertion.subject.gsub(/[\._]/, ' ')
    _assertion = decorate(assertion)
    case assertion
    when :down
    when :up
      _verb = 'is'
      _object = condition.to_s
    else
      _verb = _assertion.human_condition
      _object = _assertion.operand
    end

    [_subject, _verb, _object].join ' '
  end
  def tcp_reason
  end
  def hearbeat_reason
  end

  #def subject
  #  "━ [noty alert][#{status == 'close' ? 'UP' : 'DOWN'}] #{incident.check.uri}"
  #end

  # Short, online subject, use in email
  def subject
    "#{icon} #{short_status.upcase} noty alert for #{check.uri}"
  end

  def url
    incident_url(self)
  end

  def duration
    diff = updated_at - created_at
    hour = (diff / 3600).to_i
    if hour >= 1
      minute = (diff - (hour * 3600)).to_i / 60
      "#{pluralize(hour.to_i, 'hour')} #{pluralize(minute, 'minute')}"
    else
      minute = (diff / 60).to_i
      pluralize(minute, 'minute')
    end
  end

  # How many time this happen
  def frequency
    Incident.where(assertion: self.assertion).count
  end
end
