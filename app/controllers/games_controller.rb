class GamesController < ApplicationController
  def create
    player_id = params[:player] == 'one' ? :player_one_id : :player_two_id
    game = Game.create(player_id => current_player_or_guest.id)
    redirect_to game_path(game)
  end

  def show
    @game = Game.find_by_slug!(params[:slug])
  end

  def accept_invite
    @game = Game.invitation_pending.find_by_slug!(params[:slug])
    @game.accept_invitation(current_player)
    ActionCable.server.broadcast("game_channel_#{@game.slug}", @game.to_json)
    redirect_to game_path(@game)
  end

  def play
    @game = Game.in_progress.where(player_with_turn_id: current_player.id).find_by_slug!(params[:slug])
    @game.play(params[:move])
    ActionCable.server.broadcast("game_channel_#{@game.slug}", @game.to_json)
  end

  def rematch
    @game = Game.completed.find_by_slug!(params[:slug])
    return false if @game.player_one_id != current_player.id && @game.player_two_id != current_player.id

    if params[:rematch_action] == 'request'
      @game.update(rematch_requester_id: current_player.id, rematch_status: :requested)
    elsif params[:rematch_action] == 'accept'
      new_game = Game.create(player_one: @game.player_two)
      new_game.accept_invitation(@game.player_one)
      @game.update(rematch_status: :accepted, rematch_slug: new_game.slug)
    elsif params[:rematch_action] == 'decline'
      @game.update(rematch_status: :declined)
    end
    ActionCable.server.broadcast("game_channel_#{@game.slug}", @game.to_json)
  end
end
