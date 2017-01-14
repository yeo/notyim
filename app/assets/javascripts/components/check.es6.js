import React from 'react'

class Check extends React.Component {
  render () {
    return (
      <div>
        React Check Chart
        <div>Name: {this.props.name}</div>
        <div>Uri: {this.props.uri}</div>
      </div>
    )
  }
}

Check.propTypes = {
  name: React.PropTypes.string,
  uri: React.PropTypes.string
}

module.exports = Check
