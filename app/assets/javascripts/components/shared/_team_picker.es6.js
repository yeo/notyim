import React from 'react'

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
      <a href="{{ this.props.newTeamPath }}" className='nav-item'>
        <span>Team</span>
        <div style={{display: 'none'}}>{items}</div>
      </a>
    )
  }
}

TeamPicker.propTypes = {
  teams: React.PropTypes.array,
  newTeamPath: React.PropTypes.string,
}

module.exports = TeamPicker
