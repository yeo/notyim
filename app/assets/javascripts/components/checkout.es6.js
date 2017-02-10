import React from 'react'
import { render } from 'react-dom'

class Checkout extends React.Component {
  render () {
    console.log(this.props)

    return (
      <table className="table">
        <tbody>
          <tr>
            {Object.keys(this.props.packages).map((p) => {
              return <td>{this.props.packages[p].name}</td>
            })}
          </tr>
        </tbody>
      </table>
    )
  }
}

Checkout.propTypes = {
  packages: React.PropTypes.array,
  subscriptions: React.PropTypes.array
}

module.exports = Checkout
