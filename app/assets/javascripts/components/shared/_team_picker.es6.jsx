class TeamPicker extends React.Component {
  render () {
    const items= this.props.teams.map((team) => {
      return (
        <div key={team.id}>
        <h3>{team.name}</h3>
        </div>
      )
    })

    return (
      <div>
        <div class="nav-center">
          <%= link_to new_team_path, class: 'nav-item' do %>
            <span class="icon"><i class="fa fa-plus"></i></span>
            <span>Team</span>
          <% end %>
        </div>
        <div>Teams: {this.props.teams}</div>
      </div>
    );
  }
}

TeamPicker.propTypes = {
  teams: React.PropTypes.string
};
