class IncidentDecorator < SimpleDelegator
  include ActionView::Helpers::TextHelper

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

  def duration
    diff = updated_at - created_at
    hour = (diff / 3600).to_i
    if hour >= 1
      minute = (diff - (hour * 3600))/ 60
      "#{pluralize(hour.to_i, 'hour')} #{pluralize(minute, 'minute')}"
    else
      minute = (diff / 60).to_i
      pluralize(minute, 'minute')
    end
  end
end
