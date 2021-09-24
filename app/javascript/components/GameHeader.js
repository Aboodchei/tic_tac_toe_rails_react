import React from 'react'
function GameHeader(props) {

  const header_data = () => {
    if (props.currentPlayer.id == props.playerOne.id) {
      return("You're playing as X ⚔️")
    } else if (props.currentPlayer.id == props.playerTwo.id) {
      return("You're playing as O 🛡")
    } else {
      return("You're watching an exciting game between " + props.playerOne.displayName + "⚔️ and "+ props.playerTwo.displayName + "🛡")
    }
  }

  const turn_data = () => {
    if(props.game_completed){
      return("Game over")
    }
    if (!props.current_player_is_playing) {
      return("It's " + props.playerWithTurn.displayName + "'s turn")
    } else if (props.currentPlayer.id == props.playerWithTurn.id) {
      return("Your move!")
    } else {
      return("Your opponent's turn!")
    }
  }

  const winner_name = () => {
    if (props.game_completed && props.result == 'player_one_win') {
      return(props.playerOne.displayName + " Wins! ⚔️")
    } else if (props.game_completed && props.result == 'player_two_win') {
      return(props.playerTwo.displayName + " Wins! 🛡")
    } else if (props.game_completed && props.result == 'draw'){
      return("Draw!")
    } else if (!props.game_completed){
      return("Game is still in progress!")
    }
  }

  const player_link = (player) => {
    if(player.guest){
      return("Anonymous")
    }else{
      return(<a href={'/players/' + player.displayName} target='_blank'>{player.displayName}</a>)
    }
  }

  return ([
    <h1 class="display-5 fw-bold">{header_data()}</h1>,
    <div class="row">
      <div class="col-lg-9 mx-auto">
        <p>{player_link(props.playerOne)} ⚔️ VS {player_link(props.playerTwo)} 🛡</p>
        <p>{turn_data()}</p>
        <p>{winner_name()}</p>
      </div>
    </div>
  ])
}
export default GameHeader