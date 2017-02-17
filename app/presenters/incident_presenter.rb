class IncidentPresenter < ApplicationPresenter
  include ActionView::Helpers::TextHelper

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
