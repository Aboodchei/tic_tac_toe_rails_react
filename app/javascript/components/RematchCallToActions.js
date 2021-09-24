import React, { useState, useEffect } from 'react'
function RematchCallToActions(props) {

  const call_rematch_action = async (action) => {
    await fetch('/games/'+props.slug+'/rematch' , {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('[name=csrf-token]').content,
      },
      body: JSON.stringify({rematch_action: action}),
    })
  }

  const rematch_call_to_action = () => {
    if(props.can_request_rematch){
      return(
        <button onClick={() => {call_rematch_action('request')}} type="button" class="btn btn-primary btn-sm">Request Rematch</button>
      )
    }else if (props.can_accept_or_decline_rematch) {
      return([
        <button onClick={() => {call_rematch_action('accept')}} type="button" class="btn btn-success btn-sm">Accept Rematch</button>,
        <button onClick={() => {call_rematch_action('decline')}} type="button" class="btn btn-danger btn-sm">Decline Rematch</button>
      ])
    }else{
      return null
    }
  }

  return (rematch_call_to_action())
}
export default RematchCallToActions