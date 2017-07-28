
export function actionTypes(RESOURCE_NAME) {
  const REQUEST = `REQUEST_${RESOURCE_NAME}`
  const RESPONSE = `RESPONSE_${RESOURCE_NAME}`
  const RESPONSE_ERROR = `RESPONSE_ERROR_${RESOURCE_NAME}`
  const RESET_DATA = `RESET_DATA_${RESOURCE_NAME}`

  return {
    REQUEST,
    RESPONSE,
    RESPONSE_ERROR,
    RESET_DATA,
  }
}

export const request = (RESOURCE_NAME, req) => (dispatch) => {
  const { REQUEST, RESPONSE, RESPONSE_ERROR } = actionTypes(RESOURCE_NAME)

  dispatch({ type: REQUEST })

  req.then(res => {
    dispatch({
      type: RESPONSE,
      data: res.data
    })
  })
  .catch(error => {
    dispatch({ type: RESPONSE_ERROR })
  })
}

export const requestResetDataOnError = (RESOURCE_NAME, req) => (dispatch) => {
  const { REQUEST, RESPONSE, RESPONSE_ERROR, RESET_DATA } = actionTypes(RESOURCE_NAME)

  dispatch({ type: REQUEST })

  req.then(res => {
    dispatch({
      type: RESPONSE,
      data: res.data
    })
  })
  .catch(error => {
    dispatch({ type: RESPONSE_ERROR })
    dispatch({ type: RESET_DATA })
  })
}
