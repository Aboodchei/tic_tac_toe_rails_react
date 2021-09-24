import 'channels'
import React, { useState, useEffect } from 'react'
import GamesChannel from 'channels/games_channel'
import GameHeader from 'components/GameHeader'
import Game from 'components/Game'
import RematchCallToActions from 'components/RematchCallToActions'
import RematchStatus from 'components/RematchStatus'

function GameContainer(props) {
  const [slug, setSlug] = useState(props.slug)
  const [moves, setMoves] = useState(props.moves)
  const [winningCombination, setWinningCombination] = useState(props.winningCombination)
  const [result, setResult] = useState(props.result)
  const [status, setStatus] = useState(props.status)
  const [playerOne, setPlayerOne] = useState(props.playerOne)
  const [playerTwo, setPlayerTwo] = useState(props.playerTwo)
  const [playerWithTurn, setPlayerWithTurn] = useState(props.playerWithTurn)
  const [currentPlayer, setCurrentPlayer] = useState(props.currentPlayer)
  const [rematchSlug, setRematchSlug] = useState(props.rematchSlug)
  const [rematchStatus, setRematchStatus] = useState(props.rematchStatus)
  const [rematchRequesterId, setRematchRequesterId] = useState(props.rematchRequesterId)
  const [redirect, setRedirect] = useState(false)

  useEffect(() => {
    GamesChannel(props.slug).received = (data) => {
      update_states_from_data(data)
    }
  }, [])

  const update_states_from_data = (data) => {
    if(!rematchSlug && !!data.rematchSlug){
      setRedirect(true)
    }
    setSlug(data.slug)
    setMoves(data.moves)
    setWinningCombination(data.winningCombination)
    setResult(data.result)
    setStatus(data.status)
    setPlayerOne(data.playerOne)
    setPlayerTwo(data.playerTwo)
    setPlayerWithTurn(data.playerWithTurn)
    setRematchSlug(data.rematchSlug)
    setRematchStatus(data.rematchStatus)
    setRematchRequesterId(data.rematchRequesterId)
  }

  const current_player_is_playing = () => {
    return (currentPlayer.id == playerOne.id || currentPlayer.id == playerTwo.id)
  }

  const game_completed = () => {
    return(status == 'completed')
  }

  const game_header_props = () => {
    return({ result: result, status: status, playerOne: playerOne, playerTwo: playerTwo,
      playerWithTurn: playerWithTurn, currentPlayer: currentPlayer,
      game_completed: game_completed(),
      current_player_is_playing: current_player_is_playing()
    })
  }

  const game_props = () => {
    return({
      moves: moves,
      slug: slug,
      current_player_is_playing: current_player_is_playing(),
      current_player_can_play: (status == 'in_progress' && currentPlayer.id == playerWithTurn.id),
    })
  }

  const rematch_call_to_actions_props = () => {
    return({
      slug: slug,
      can_request_rematch: (game_completed() && current_player_is_playing() && rematchStatus == 'none'),
      can_accept_or_decline_rematch: (game_completed() && current_player_is_playing() && currentPlayer.id != rematchRequesterId && rematchStatus == 'requested'),
    })
  }

  const rematch_status_props = () => {
    return({
      redirect: redirect,
      rematchSlug: rematchSlug,
      rematchStatus: rematchStatus,
    })
  }

  return (
    <div class="container">
      <div class="px-4 py-5 my-2 text-center">
        <GameHeader {...game_header_props()}/>
        <div class="row">
          <div class="col-lg-4 mx-auto">
            <Game {...game_props()}/>
          </div>
        </div>
        <div class="row">
          <div class="col-lg-4 mx-auto">
            <RematchStatus {...rematch_status_props()}/>
            <RematchCallToActions {...rematch_call_to_actions_props()}/>
          </div>
        </div>
      </div>
    </div>
  )
}

export default GameContainer
