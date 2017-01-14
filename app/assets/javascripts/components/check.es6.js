import React from 'react'
import { render } from 'react-dom'
import { VictoryChart, VictoryBar, VictoryTheme, VictoryAxis } from 'victory'

const data = [
  {t: 1, v: 200},
  {t: 2, v: 201},
  {t: 3, v: 400},
  {t: 4, v: 300},
  {t: 5, v: 300},
  {t: 6, v: 300},
  {t: 7, v: 300},
  {t: 8, v: 300},
  {t: 9, v: 300},
  {t: 10, v: 300},
];

class Check extends React.Component {
  render () {
    return (
      <VictoryChart
        // adding the material theme provided with Victory
        theme={VictoryTheme.material}
        domainPadding={50}
      >
        <VictoryAxis
          dependentAxis
          tickFormat={(x) => (`$${x / 1000}ms`)}
        />
        <VictoryBar
          data={data}
          x="t"
          y="v"
        />
      </VictoryChart>
    )
  }
}

Check.propTypes = {
  name: React.PropTypes.string,
  uri: React.PropTypes.string
}

module.exports = Check
