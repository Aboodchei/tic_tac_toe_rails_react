import 'channels'
import React, { useState, useEffect } from 'react'
import GamesChannel from 'channels/games_channel'
import { Table } from 'react-bootstrap';

function Game(props) {
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

  useEffect(() => { 
    GamesChannel(props.slug).received = (data) => {
      handle_populated_slug(data)
      update_states_from_data(data)
    }
  }, [])

  const handle_populated_slug = (data) => {
    if(!rematchSlug && !!data.rematchSlug){
      window.location.href = "/" + data.rematchSlug
    }
  }

  const update_states_from_data = (data) => {
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
  const header_data = () => {
    if (currentPlayer.id == playerOne.id) {
      return("You're playing as X ⚔️")
    } else if (currentPlayer.id == playerTwo.id) {
      return("You're playing as O 🛡")
    } else {
      return("You're watching an exciting game between " + playerOne.displayName + "⚔️ and "+ playerTwo.displayName + "🛡")
    }
  }

  const turn_data = () => {
    if(game_completed()){
      return("Game over")
    }
    if (!current_player_is_playing()) {
      return("It's " + playerWithTurn.displayName + "'s turn")
    } else if (currentPlayer.id == playerWithTurn.id) {
      return("Your move!")
    } else {
      return("Your opponent's turn!")
    }
  }

  const can_play = (move) => {
    return(status == 'in_progress' && currentPlayer.id == playerWithTurn.id && moves[move][0] == 'playable')
  }

  const game_completed = () => {
    return(status == 'completed')
  }

  const winner_name = () => {
    if (game_completed() && result == 'player_one_win') {
      return(playerOne.displayName + " Wins! ⚔️")
    } else if (game_completed() && result == 'player_two_win') {
      return(playerTwo.displayName + " Wins! 🛡")
    } else if (game_completed() && result == 'draw'){
      return("Draw!")
    } else if (!game_completed()){
      return("Game is still in progress!")
    }
  }

  const play = async (move) => {
    if(!can_play(move)){
      return false
    }

    await fetch('/games/'+slug+'/play' , {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('[name=csrf-token]').content,
      },
      body: JSON.stringify({move: move}),
    })
  }

  const call_rematch_action = async (action) => {
    await fetch('/games/'+slug+'/rematch' , {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('[name=csrf-token]').content,
      },
      body: JSON.stringify({rematch_action: action}),
    })
  }

  const can_request_rematch = () => {
    return(game_completed() && current_player_is_playing() && rematchStatus == 'none')
  }

  const can_accept_or_decline_rematch = () => {
    return(game_completed() && current_player_is_playing() && currentPlayer.id != rematchRequesterId && rematchStatus == 'requested')
  }

  const request_rematch = async () => {
    call_rematch_action('request')
  }

  const accept_rematch = async () => {
    call_rematch_action('accept')
  }

  const decline_rematch = async () => {
    call_rematch_action('decline')
  }

  const td_class = (block) => {
    var classes = "game_td game_td_" + block
    if(moves[block][0] == "winning_move"){
      classes += " game_td_winning"
    }
    return classes
  }

  const player_link = (player) => {
    if(player.guest){
      return("Anonymous")
    }else{
      return(<a href={'/players/' + player.displayName} target='_blank'>{player.displayName}</a>)
    }
  }

  const rematch_call_to_action = () => {
    if(can_request_rematch()){
      return(
        <button onClick={() => {request_rematch()}} type="button" class="btn btn-primary btn-sm">Request Rematch</button>
      )
    }else if (can_accept_or_decline_rematch()) {
      return([
        <button onClick={accept_rematch} type="button" class="btn btn-success btn-sm">Accept Rematch</button>,
        <button onClick={decline_rematch} type="button" class="btn btn-danger btn-sm">Decline Rematch</button>
      ])
    }
  }

  const rematch_status = () => {
    if(rematchStatus != 'none'){
      return(<p class="">Rematch {rematchStatus}</p>)
    }
  }

  return (
    <div class="container">
      <div class="px-4 py-5 my-2 text-center">
        <h1 class="display-5 fw-bold">{header_data()}</h1>
        <div class="row">
          <div class="col-lg-9 mx-auto">
            <p>{player_link(playerOne)} ⚔️ VS {player_link(playerTwo)} 🛡</p>
            <p>{turn_data()}</p>
            <p>{winner_name()}</p>
          </div>
        </div>
        <div class="row">
          <div class="col-lg-4 mx-auto">
          <Table className='game_table'>
            <tbody>
              <tr class="game_tr">
                  <td onClick={() => {play('1')}} class={td_class(1)}>{moves['1'][1]}</td>
                  <td onClick={() => {play('2')}} class={td_class(2)}>{moves['2'][1]}</td>
                  <td onClick={() => {play('3')}} class={td_class(3)}>{moves['3'][1]}</td>
              </tr>
              <tr class="game_tr">
                  <td onClick={() => {play('4')}} class={td_class(4)}>{moves['4'][1]}</td>
                  <td onClick={() => {play('5')}} class={td_class(5)}>{moves['5'][1]}</td>
                  <td onClick={() => {play('6')}} class={td_class(6)}>{moves['6'][1]}</td>
              </tr>
              <tr class="game_tr">
                  <td onClick={() => {play('7')}} class={td_class(7)}>{moves['7'][1]}</td>
                  <td onClick={() => {play('8')}} class={td_class(8)}>{moves['8'][1]}</td>
                  <td onClick={() => {play('9')}} class={td_class(9)}>{moves['9'][1]}</td>
              </tr>
            </tbody>
          </Table>
          </div>
        </div>
        <div class="row">
          <div class="col-lg-4 mx-auto">
            {rematch_status()}
            {rematch_call_to_action()}
          </div>
        </div>
      </div>
    </div>
  )
}

export default Game
