import React, { Component as ReactComponent, PropTypes } from 'react'
import { Provider } from 'react-redux'
import createStore from '../store'
import AppLayout from './app-layout'
import $ from 'jquery'

export default function app(reducers={}, Component) {
  const store = createStore(reducers)

  return class App extends ReactComponent {
    componentDidMount() {
      this.removePreloader()
    }

    removePreloader() {
      $('#react-loading').fadeOut('normal', () => $(this).remove())
    }

    render() {
      return (
        <Provider store={store}>
          <AppLayout>
            <Component />
          </AppLayout>
        </Provider>
      )
    }
  }
}
