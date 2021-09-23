class SessionsController < Devise::SessionsController
  skip_before_action :require_no_authentication

  def new
    sign_out(current_player) if current_player
    super
  end
end