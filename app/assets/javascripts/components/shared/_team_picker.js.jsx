var TeamPicker = React.createClass({
  render() {
    var items= this.props.teams.map((team) => {
      return (
        <div key={team.id}>
        <h3>{team.name}</h3>
        </div>
      )
    });

    return(
      <div>
      {items}
      </div>
    )
  }
})
