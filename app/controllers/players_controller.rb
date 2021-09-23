class PlayersController < ApplicationController
  def show
    @player = Player.find_by_username(params[:username])
  end
end
