class CheckEditor extends React.Component {
  render () {
    return (
      <div>
        <div>Name: {this.props.name}</div>
        <div>Uri: {this.props.uri}</div>
        <div>Type: {this.props.type}</div>
      </div>
    );
  }
}

CheckEditor.propTypes = {
  name: React.PropTypes.string,
  uri: React.PropTypes.string,
  type: React.PropTypes.string
};
