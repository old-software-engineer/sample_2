import React, { Component, PropTypes } from 'react'
import {
  Dialog,
  Card,
  CardMedia,
  CardText,
  FloatingActionButton,
} from 'material-ui'
import ArrowBack from 'material-ui/svg-icons/navigation/arrow-back'
import ArrowForward from 'material-ui/svg-icons/navigation/arrow-forward'
import ContentClear from 'material-ui/svg-icons/content/clear'
import RaisedButton from '../components/raised-button'
import FlatButton from '../components/flat-button'
import ONBRD_SLIDE_1_IMAGE from '../images/onbrdimg1-AddItem.png'
import ONBRD_SLIDE_2_IMAGE from '../images/onbrdimg2-OrganizeOrders.png'
import ONBRD_SLIDE_3_IMAGE from '../images/onbrdimg3-Automateorderfulfilment.png'

const IMAGES = [
  ONBRD_SLIDE_1_IMAGE,
  ONBRD_SLIDE_2_IMAGE,
  ONBRD_SLIDE_3_IMAGE,
]

export default class GetStarted extends Component {
  static propTypes = {
    show: PropTypes.bool,
    onClose: PropTypes.func,
  }

  state = {
    page: 1
  }

  onClickForward() {
    if (this.state.page < IMAGES.length) {
      this.setState({ page: this.state.page + 1})
    }
    else {
      this.props.onClose()
    }
  }

  onClickBack() {
    if ((this.state.page <= IMAGES.length) && (this.state.page >= 1)) {
      this.setState({ page: this.state.page - 1})
    }
  }

  renderImage() {
    return (
      <img src={IMAGES[this.state.page - 1]} style={styles.img} />
    )
  }

  renderContentTxt() {
    if (this.state.page == 1) {
      return (
        <div style={styles.flex}>
          <h3 style={styles.headingStyle}>Add Item Description</h3>
          <div>Adding into your space each SKU with the height, length, width and</div>
          <div>weight of your items into your space is now simple and easy to do.</div>
        </div>
      )
    } else if (this.state.page == 2) {
      return (
        <div style={styles.flex}>
          <h3 style={styles.headingStyle}>Organize In/Outbound Orders</h3>
          <div>Enjoy the convenience of organizing your inbound and outbound orders,</div>
          <div>all from your account knowing orders are deliver on time.</div>
        </div>

      )
    } else {
      return (
        <div style={styles.flex}>
          <h3 style={styles.headingStyle}>Automate Order Fulfilment.</h3>
          <div>Simple review your automated orders being notified of their status</div>
          <div>as you continue to build your business, or just enjoy having your time back!</div>
        </div>
      )
    }
  }

  render() {
    const actions = [
      <FlatButton
        label="Back"
        primary={true}
        disabled={this.state.page <= 1}
        onTouchTap={() => this.onClickBack()}
      />,
      <RaisedButton
        label={this.state.page == 3 ? "Close" : "Next" }
        primary={true}
        onTouchTap={() => this.onClickForward()}
      />,
    ]

    return (

      <Dialog
        modal={true}
        open={this.props.show}
        onRequestClose={this.props.onClose}
        actions={actions}
        bodyStyle={styles.dialogBodyStyle}
        contentStyle={styles.dialogCntntStyle}
        overlayStyle={styles.dialogBody}
        actionsContainerStyle={styles.dialogBody}>
        <Card>
          <CardMedia>{this.renderImage()}</CardMedia>
          <CardText style={styles.crdTxt}>
            {this.renderContentTxt()}
          </CardText>
        </Card>
        <div style={styles.arrowBkStyle}>
          <FloatingActionButton
            disabled={this.state.page <= 1}
            mini={true}
            secondary
            onTouchTap={() => this.onClickBack()}>
            <ArrowBack/>
          </FloatingActionButton>
        </div>
        <div style={styles.arrowFrwrdStyle}>
          <FloatingActionButton
            mini={true}
            secondary
            onTouchTap={() => this.onClickForward()}>
            {this.state.page == IMAGES.length ? <ContentClear /> : <ArrowForward />}
          </FloatingActionButton>
        </div>
      </Dialog>

    )
  }
}

const styles = {
  img: {
    maxWidth:10,
    height: 200
  },
  flex: {
    display: 'flex',
    flexDirection: 'column',
    justifyContent: 'center',
    alignItems: 'center',
  },
  crdTxt: {
    minHeight:150,
  },
  dialogBodyStyle: {
    maxWidth:600,
    padding: 0
  },
  dialogCntntStyle: {
    maxWidth:600,
    padding: 0,

  },
  dialogBody: {
    backgroundColor: 'rgba(255, 255, 255, 0.7)'
  },
  headingStyle: {
    fontSize: 24,
    margin: '10px 0'
  },
  arrowBkStyle: {
    position: 'fixed',
    top: 170,
    left: -70,
    maxWidth:10
  },
  arrowFrwrdStyle: {
    position: 'fixed',
    top: 170,
    left: 623,
  }
}
