class UserDecorator < SimpleDelegator
  def open_incident(team)
    # TODO cache, add team
    incidents.of_team(team).open.count
  end

  # Return a list of user team
  def my_teams
    TeamService.fetch_user_teams(self)
  end
end
