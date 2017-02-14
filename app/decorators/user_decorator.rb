class UserDecorator < SimpleDelegator
  def open_incident
    incidents.open.count
  end
end
