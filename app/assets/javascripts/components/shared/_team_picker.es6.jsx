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
        <div className="nav-center">
          <a href="{this.props.newTeamPath}" className='nav-item'>
            <span className="icon"><i className="fa fa-plus"></i></span>
            <span>Team</span>
          </a>
        </div>
        <div>{items}</div>
      </div>
    )
  }
}

TeamPicker.propTypes = {
  teams: React.PropTypes.array,
  newTeamPath: React.PropTypes.string,
}
