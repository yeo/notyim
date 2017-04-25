class UserDecorator < SimpleDelegator
  def open_incident
    # TODO cache, add team
    incidents.open.count
  end

  # Return a list of user team
  def my_teams
    TeamService.fetch_user_teams(self)
  end
end
