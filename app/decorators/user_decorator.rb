class UserDecorator < SimpleDelegator
  def open_incident
    # TODO cache, add team
    incidents.open.count
  end
end
