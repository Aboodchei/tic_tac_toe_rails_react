module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :game_id,

    def connect
      self.slug = Game.find(params[:slug])
    end
  end
end
