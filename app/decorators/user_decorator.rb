class UserDecorator < SimpleDelegator
  def open_incident
    # TODO cache
    incidents.open.count
  end
end
