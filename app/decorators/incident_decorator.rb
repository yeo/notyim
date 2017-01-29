class IncidentDecorator < SimpleDelegator
  def short_status
    case status
    when Incident::STATUS_OPEN
      'open'
    when Incident::STATUS_CLOSE
      'close'
    end
  end

  def short_summary
    "#{short_status} [noty alert]"
  end

  def subject
    "━ [noty alert][#{status == 'close' ? 'UP' : 'DOWN'}] #{incident.check.uri}"
  end
end
