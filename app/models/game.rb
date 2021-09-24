# == Schema Information
#
# Table name: games
#
#  id                   :bigint           not null, primary key
#  moves                :string           default([]), is an Array
#  rematch_slug         :string
#  rematch_status       :integer          default(0)
#  result               :integer          default("not_applicable"), not null
#  slug                 :string           default(""), not null
#  status               :integer          default("invitation_pending"), not null
#  winning_combination  :string           default([]), is an Array
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
#  player_one_id        :bigint
#  player_two_id        :bigint
#  player_with_turn_id  :bigint
#  rematch_requester_id :bigint
#
# Indexes
#
#  index_games_on_player_one_id         (player_one_id)
#  index_games_on_player_two_id         (player_two_id)
#  index_games_on_player_with_turn_id   (player_with_turn_id)
#  index_games_on_rematch_requester_id  (rematch_requester_id)
#  index_games_on_slug                  (slug)
#
# Foreign Keys
#
#  fk_rails_...  (player_one_id => players.id)
#  fk_rails_...  (player_two_id => players.id)
#  fk_rails_...  (player_with_turn_id => players.id)
#  fk_rails_...  (rematch_requester_id => players.id)
#
class Game < ApplicationRecord
  belongs_to :player_one, class_name: 'Player', optional: true
  belongs_to :player_two, class_name: 'Player', optional: true
  belongs_to :player_with_turn, class_name: 'Player', optional: true
  belongs_to :rematch_requester, class_name: 'Player', optional: true

  enum status: { invitation_pending: 0, in_progress: 1, completed: 2 }
  enum result: { not_applicable: 0, player_one_win: 1, player_two_win: 2, draw: 3 }, _prefix: true
  enum rematch_status: { none: 0, requested: 1, accepted: 2, declined: 3 }, _prefix: true

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
      player_one.update(win_count: player_one.win_count + 1)
      player_two.update(loss_count: player_two.loss_count + 1)
      :player_one_win
    elsif winner?(player_two_moves)
      player_two.update(win_count: player_two.win_count + 1)
      player_one.update(loss_count: player_one.loss_count + 1)
      :player_two_win
    elsif moves.count == 9
      player_one.update(draw_count: player_one.draw_count + 1)
      player_two.update(draw_count: player_two.draw_count + 1)
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
      if (combination - moves_array).blank?
        update(winning_combination: combination)
        return true
      end
    end
    false
  end

  def accept_invitation(player)
    key = player_one_id? ? :player_two_id : :player_one_id
    update(status: :in_progress, player_with_turn_id: player_one_id || player.id, key => player.id)
  end

  def generate_slug
    generated_slug = SecureRandom.alphanumeric(6)
    if Game.where(slug: generated_slug).exists?
      generate_slug
    else
      update(slug: generated_slug)
    end
  end

  def inviter
    player_one || player_two
  end

  def to_param
    slug
  end

  def to_json
    {
      slug: slug,
      moves: moves_to_json,
      result: result,
      status: status,
      winningCombination: winning_combination,
      playerOne: {
        id: player_one_id,
        displayName: player_one&.display_name,
        guest: player_one && player_one&.guest?
      },
      playerTwo: {
        id: player_two_id,
        displayName: player_two&.display_name,
        guest: player_two && player_two&.guest?
      },
      playerWithTurn: {
        id: player_with_turn_id,
        displayName: player_with_turn&.display_name
      },
      rematchSlug: rematch_slug,
      rematchStatus: rematch_status,
      rematchRequesterId: rematch_requester_id
    }
  end

  def moves_to_json
    {}.tap do |data|
      (1..9).each do |number|
        block = number.to_s
        move_index = moves.index(block)
        played = move_index % 2 == 0 ? 'X' : 'O' if move_index.present?
        data[block] = if winning_combination.index(block).present?
                        ['winning_move', played]
                      elsif move_index.present?
                        ['played', played]
                      else
                        ['playable', nil]
                      end
      end
    end
  end
end
