class GamesChannel < ApplicationCable::Channel
  def subscribed
    game = Game.find_by_slug!(params[:slug])
    stream_from "game_channel_#{game.slug}"
    ActionCable.server.broadcast("game_channel_#{game.slug}", game.to_json)
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
