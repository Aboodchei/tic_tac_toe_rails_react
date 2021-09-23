class ApplicationController < ActionController::Base
  helper_method :current_player_or_guest

  def current_player_or_guest
    current_player || create_and_sign_in_guest_player
  end

  private

  def create_and_sign_in_guest_player
    player = Player.create(username: SecureRandom.urlsafe_base64(6), password: SecureRandom.urlsafe_base64(6), guest: true)
    sign_in(:player, player)
    player
  end
end
