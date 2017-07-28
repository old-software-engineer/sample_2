import React, { Component, PropTypes } from 'react'
import { MuiThemeProvider, getMuiTheme, spacing } from 'material-ui/styles'
import { blue500, red500 } from 'material-ui/styles/colors'
import injectTapEventPlugin from 'react-tap-event-plugin'
injectTapEventPlugin()

const muiTheme = getMuiTheme({
  palette: {
    primary1Color: blue500,
    accent1Color: red500,
  },
  fontFamily: 'Roboto',
})

export default class AppLayout extends Component {
  static defaultProps = { children: null }

  render() {
    return (
      <MuiThemeProvider muiTheme={muiTheme}>
        {this.props.children}
      </MuiThemeProvider>
    )
  }
}
