export const ADD_OR_UPDATE_BOOKING_ITEM = "ADD_OR_UPDATE_BOOKING_ITEM"
export const UPDATE_BOOKING_ITEM = "UPDATE_BOOKING_ITEM"
export const REMOVE_BOOKING_ITEM = "REMOVE_BOOKING_ITEM"
export const REMOVE_ALL_BOOKING_ITEMS = "REMOVE_ALL_BOOKING_ITEMS"

export const addOrUpdateBookingItem = (id, quantity = 0) => ({
  type: ADD_OR_UPDATE_BOOKING_ITEM,
  payload: {
    id,
    quantity,
  }
})

export const updateBookingItem = (id, quantity = 0) => ({
  type: UPDATE_BOOKING_ITEM,
  payload: {
    id,
    quantity,
  }
})

export const removeBookingItem = (id) => ({
  type: REMOVE_BOOKING_ITEM,
  payload: {
    id
  }
})

export const removeAllBookingItems = () => ({
  type: REMOVE_ALL_BOOKING_ITEMS
})
