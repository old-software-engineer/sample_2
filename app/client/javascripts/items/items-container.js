import React, { Component, PropTypes } from 'react'
import { bindActionCreators } from 'redux'
import { connect } from 'react-redux'
import Items from './items'
import router from '../components/router'
import { newDeliveryPath, newItemPath } from '../api'
import * as itemsActions from '../actions/items-actions'

class ItemsContainer extends Component {
  static propTypes = {
    items: PropTypes.object.isRequired,
    bookingItems: PropTypes.object.isRequired,
    getItems: PropTypes.func.isRequired,
    goTo: PropTypes.func.isRequired,
  }

  componentDidMount() {
    this.props.getItems()
  }

  goToNewDelivery() {
    const itemIds = this.props.bookingItems.ids
    this.props.goTo(newDeliveryPath({ itemIds }))
  }

  goToNewItem() {
    this.props.goTo(newItemPath())
  }

  render() {
    return (
      <Items
        {...this.props.items}
        onFetchRetry={this.props.getItems}
        onClickDelivery={() => this.goToNewDelivery()}
        onClickPickUp={() => this.goToNewItem()}
      />
    )
  }
}

const props = (state) => ({
  items: state.items,
  bookingItems: state.session.bookingItems,
})

const dispatches = dispatch => bindActionCreators(itemsActions, dispatch)

export default router(connect(props, dispatches)(ItemsContainer))
