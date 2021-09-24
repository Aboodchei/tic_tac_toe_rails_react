import React from 'react'
import { Table } from 'react-bootstrap';

function Game(props) {

  const play = async (block) => {
    if(!(props.current_player_is_playing && props.current_player_can_play && props.moves[block][0] == 'playable')){
      return false
    }

    await fetch('/games/'+props.slug+'/play' , {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-TOKEN': document.querySelector('[name=csrf-token]').content,
      },
      body: JSON.stringify({move: block}),
    })
  }

  const td_class = (block) => {
    var classes = "game_td game_td_" + block
    if(props.moves[block][0] == "winning_move"){
      classes += " game_td_winning"
    }
    return classes
  }

  return (
    <Table className='game_table'>
      <tbody>
        <tr class="game_tr">
            <td onClick={() => play('1') } class={td_class('1')}>{props.moves['1'][1]}</td>
            <td onClick={() => play('2') } class={td_class('2')}>{props.moves['2'][1]}</td>
            <td onClick={() => play('3') } class={td_class('3')}>{props.moves['3'][1]}</td>
        </tr>
        <tr class="game_tr">
            <td onClick={() => play('4') } class={td_class('4')}>{props.moves['4'][1]}</td>
            <td onClick={() => play('5') } class={td_class('5')}>{props.moves['5'][1]}</td>
            <td onClick={() => play('6') } class={td_class('6')}>{props.moves['6'][1]}</td>
        </tr>
        <tr class="game_tr">
            <td onClick={() => play('7') } class={td_class('7')}>{props.moves['7'][1]}</td>
            <td onClick={() => play('8') } class={td_class('8')}>{props.moves['8'][1]}</td>
            <td onClick={() => play('9') } class={td_class('9')}>{props.moves['9'][1]}</td>
        </tr>
      </tbody>
    </Table>
  )
}

export default Game
