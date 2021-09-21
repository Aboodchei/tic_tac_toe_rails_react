# == Schema Information
#
# Table name: games
#
#  id                  :bigint           not null, primary key
#  moves               :string           default([]), is an Array
#  result              :integer          default("not_applicable"), not null
#  slug                :string           default(""), not null
#  status              :integer          default("invitation_pending"), not null
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  player_one_id       :bigint
#  player_two_id       :bigint
#  player_with_turn_id :bigint
#
# Indexes
#
#  index_games_on_player_one_id        (player_one_id)
#  index_games_on_player_two_id        (player_two_id)
#  index_games_on_player_with_turn_id  (player_with_turn_id)
#  index_games_on_slug                 (slug)
#
# Foreign Keys
#
#  fk_rails_...  (player_one_id => players.id)
#  fk_rails_...  (player_two_id => players.id)
#  fk_rails_...  (player_with_turn_id => players.id)
#
class Game < ApplicationRecord
  belongs_to :player_one, class_name: 'Player', optional: true
  belongs_to :player_two, class_name: 'Player', optional: true
  belongs_to :player_with_turn, class_name: 'Player', optional: true

  enum status: { invitation_pending: 0, in_progress: 1, completed: 2 }
  enum result: { not_applicable: 0, player_one_win: 1, player_two_win: 2, draw: 3 }, _prefix: true

  after_create :generate_slug

  WINNING_COMBINATIONS = [
    ['1','2','3'],
    ['4','5','6'],
    ['7','8','9'],
    ['1','4','7'],
    ['1','5','9'],
    ['2','5','8'],
    ['3','5','7'],
    ['3','6','9'],
  ].freeze

  def player_one_turn?
    player_with_turn_id && player_with_turn_id == player_one_id
  end

  def player_two_turn?
    player_with_turn_id && player_with_turn_id == player_two_id
  end

  def play(move)
    if can_play?(move.to_i)
      moves << move.to_s
      save
      update_result
      update_status
      update_player_with_turn
    end
  end

  def can_play?(move)
    in_progress? && move <= 9 && move >= 1 && !moves.include?(move.to_s)
  end

  def update_player_with_turn
    id = result_not_applicable? ? (moves.length % 2 == 0 ? player_one_id : player_two_id ) : nil
    update(player_with_turn_id: id)
  end

  def update_result
    player_one_moves, player_two_moves = moves.partition.each_with_index{ |_, i| i.even? }
    computed_result = if winner?(player_one_moves)
      :player_one_win
    elsif winner?(player_two_moves)
      :player_two_win
    elsif moves.count == 9
      :draw
    else
      :not_applicable
    end
    update(result: computed_result)
  end

  def update_status
    update(status: result_not_applicable? ? :in_progress : :completed)
  end

  def winner?(moves_array)
    WINNING_COMBINATIONS.each do |combination|
      return true if (combination - moves_array).blank?
    end
    false
  end

  def accept_invitation(player)
    if !player_one_id?
      update(player_one_id: player.id)
    else
      update(player_two_id: player.id)
    end
    update(status: :in_progress, player_with_turn_id: player_one_id)
  end

  def generate_slug
    generated_slug = SecureRandom.urlsafe_base64(6)
    if Game.where(slug: generated_slug).exists?
      generate_slug
    else
      update(slug: generated_slug)
    end
  end
end
