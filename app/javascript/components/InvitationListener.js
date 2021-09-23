import 'channels'
import React, { useEffect } from 'react'
import GamesChannel from 'channels/games_channel'

function InvitationListener(props) {

  useEffect(() => { 
    GamesChannel(props.game_slug).received = (data) => {
      if(data.status == 'in_progress'){
        location.reload();
      }
    }
  }, [])

  return ('');
}

export default InvitationListener
