import React, { useState, useEffect } from 'react'
function RematchStatus(props) {
  const  redirect = () => {
    return(props.redirect && props.rematchSlug && (window.location.href = "/" + props.rematchSlug) && null)
  }

  return (
    <p>{props.rematchStatus && props.rematchStatus != 'none' && (redirect() || <span>Rematch {props.rematchStatus}</span>)}</p>
  )
}
export default RematchStatus